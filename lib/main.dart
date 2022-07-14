import 'dart:io';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:test_music_player/widgets/side_panel.dart';
import 'package:test_music_player/widgets/player_panel.dart';
import 'package:test_music_player/widgets/song.dart';

void main() {
  runApp(
    const MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
    ),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool panelIsExtended = true;
  String prefsKey = "7810298896";
  String splitChar = "|";
  List<Song> songList = [
    const Song(
        path: "/home/sebastianhollow/Music/Little Talkings.mp3",
        name: "Little Talkings",
        artist: "Sailing Dogs"),
    const Song(
        path: "/home/sebastianhollow/Music/The Pill.mp3",
        name: "The Pill",
        artist: "Alex Bogdos"),
  ];

  @override
  void initState() {
    super.initState();
    retrieveSongs().then((value) => setState(() {}));
  }

  // ** Song State Machine **

  final player = AudioPlayer();
  late bool isPlaying = false;
  late bool clearCache = false;
  late int currentIndex = -1;

  late Song currentSong = const Song(path: "", name: "", artist: "");

  Future<void> setSong({required Song song, bool play = false}) async {
    final String path = song.path;

    bool exists = await File(path).exists();
    if (exists == false) {
      return;
    }

    await player.release();
    clearCache = true;

    await player.setSource(DeviceFileSource(path));

    if (play == true) {
      await player.resume();
      if (isPlaying == false) {
        isPlaying = true;
      }
    }

    setState(() {
      currentSong = song;
    });
  }

  void setIndex({required int index}) {
    if (index >= 0 && index < songList.length) {
      currentIndex = index;
    }
  }

  int getIndex() {
    return currentIndex;
  }

  bool getPlayState() {
    return isPlaying;
  }

  bool checkCache() {
    return clearCache;
  }

  void doClearCache() {
    clearCache = false;
  }

  Future<void> changePlayState() async {
    setState(() {
      isPlaying = !isPlaying;
    });

    if (isPlaying == true) {
      await player.resume();
    } else {
      await player.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Variables
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    final double panelWidth =
        panelIsExtended == true ? max(min(width * 0.3, 440), 320) : 0;

    final double playerWidth = width - panelWidth;
    final double playerHeight = height * 0.836;

    final double logoWidth = min(playerWidth * 0.48, 380);
    final double logoHeight = min(playerHeight * 0.48, 380);
    final double logoSize = max(min(logoWidth, logoHeight), 180);

    const Color panelColor = Color(0xFFECEDF5);
    const Color backgroundColor = Color(0xFFB6BFDA);

    final Color shadowColor = const Color(0xFF889DC3).withOpacity(0.25);
    const double blurRadius = 8;

    final double iconSize = max(min(width * 0.036, 35), 25);
    final Color iconColor = const Color(0xFF172329).withOpacity(0.95);

    const Color mainColor = Color(0xFF172329);
    const Color secondaryColor = Color(0xFF51698C);

    // Functions
    void changePanelStatus() {
      setState(() {
        panelIsExtended = !panelIsExtended;
      });
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: PlayerPanel(
              width: width,
              playerWidth: playerWidth,
              playerHeight: playerHeight,
              panelIsExtended: panelIsExtended,
              logoSize: logoSize,
              panelColor: panelColor,
              shadowColor: shadowColor,
              blurRadius: blurRadius,
              secondaryColor: secondaryColor,
              songList: songList,
              currentSong: currentSong,
              player: player,
              changePlayState: changePlayState,
              isPlaying: isPlaying,
              getPlayState: getPlayState,
              checkCache: checkCache,
              doClearCache: doClearCache,
              setIndex: setIndex,
              getIndex: getIndex,
              setSong: setSong,
            ),
          ),
          Align(
            alignment: const Alignment(0.99, -0.968),
            child: IconButton(
              icon: const Icon(Icons.settings_outlined),
              iconSize: iconSize,
              color: iconColor,
              splashRadius: 26,
              splashColor: shadowColor.withOpacity(0.4),
              focusColor: shadowColor.withOpacity(0.4),
              hoverColor: shadowColor.withOpacity(0.2),
              highlightColor: shadowColor.withOpacity(0.2),
              onPressed: () {},
            ),
          ),
          if (panelIsExtended == true)
            Stack(
              children: [
                SidePanel(
                  panelWidth: panelWidth,
                  height: height,
                  songList: songList,
                  panelColor: panelColor,
                  shadowColor: shadowColor,
                  blurRadius: blurRadius,
                  mainTextColor: mainColor,
                  secondaryColor: secondaryColor,
                  iconSize: iconSize,
                  currentSong: currentSong,
                  setSong: setSong,
                  getPlayState: getPlayState,
                  changePlayState: changePlayState,
                  setIndex: setIndex,
                ),
                Align(
                  alignment: const Alignment(-0.99, -0.968),
                  child: IconButton(
                    icon: const Icon(Icons.close_fullscreen_rounded),
                    iconSize: iconSize,
                    color: iconColor,
                    splashColor: shadowColor.withOpacity(0.4),
                    focusColor: shadowColor.withOpacity(0.4),
                    hoverColor: shadowColor.withOpacity(0.2),
                    highlightColor: shadowColor.withOpacity(0.2),
                    onPressed: () {
                      changePanelStatus();
                    },
                  ),
                ),
              ],
            )
          else
            Align(
              alignment: const Alignment(-0.99, -0.968),
              child: IconButton(
                icon: const Icon(Icons.open_in_full_rounded),
                iconSize: iconSize,
                color: iconColor,
                splashRadius: 26,
                splashColor: shadowColor.withOpacity(0.4),
                focusColor: shadowColor.withOpacity(0.4),
                hoverColor: shadowColor.withOpacity(0.2),
                highlightColor: shadowColor.withOpacity(0.2),
                onPressed: () {
                  changePanelStatus();
                },
              ),
            ),
        ],
      ),
    );
  }

  Future<void> retrieveSongs() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey(prefsKey) == false) {
      return;
    }
    List<String>? stringList = prefs.getStringList(prefsKey);

    if (stringList == null) {
      return;
    }

    List<Song> list = [];
    for (String str in stringList) {
      List<String> data = str.split(splitChar);
      Song song = Song(path: data[0], name: data[1], artist: data[2]);
      list.add(song);
    }

    songList = list;
  }

  Future<void> saveSongs() async {
    List<String> stringList = [];
    for (Song song in songList) {
      String data =
          "${song.path}$splitChar${song.name}$splitChar${song.artist}";
      stringList.add(data);
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(prefsKey, stringList);
  }
}
