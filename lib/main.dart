import 'dart:io' as io;
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_music_player/pages/settings_page.dart';

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
  String prefsKey = "60149469";
  String splitChar = "|";

  List<String> directories = [];

  List<Song> songList = [];

  @override
  void initState() {
    super.initState();
    retrieveDirectories().then((value) => setState(() {}));
  }

  // ** Song State Machine **

  final player = AudioPlayer();
  late bool isPlaying = false;
  late bool clearCache = false;
  late int currentIndex = -1;

  late Song currentSong = const Song(path: "", name: "", artist: "");

  Future<void> setSong({required Song song, bool play = false}) async {
    final String path = song.path;

    bool exists = await io.File(path).exists();
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
    checkPermission();
    checkExistance();
    scanDirectories();

    if (songList.isEmpty) {
      isPlaying = false;
      clearCache = false;
      currentIndex = -1;

      currentSong = const Song(path: "", name: "", artist: "");
      player.release();
    }

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
              onPressed: () {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder: (context) => SettingsPage(
                          directories: directories,
                          backgroundColor: backgroundColor,
                          panelColor: panelColor,
                          mainColor: mainColor,
                          secondaryColor: secondaryColor,
                          iconColor: iconColor,
                          shadowColor: shadowColor,
                          blurRadius: blurRadius,
                          saveDirectories: saveDirectories,
                        ),
                      ),
                    )
                    .then((value) => setState(() {}));
              },
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
                  mainColor: mainColor,
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

  void checkExistance() {
    for (int index = songList.length - 1; index >= 0; index--) {
      Song song = songList[index];
      bool exists = io.File(song.path).existsSync();
      if (exists == false) {
        songList.removeAt(index);
      }
    }
  }

  void scanDirectories() {
    songList = [];
    for (String dir in directories) {
      List<io.FileSystemEntity> files = io.Directory(dir).listSync();
      for (var file in files) {
        String extension = file.path.substring(file.path.length - 3);
        if (extension == "mp3") {
          List<String> data = file.path.split("/");

          String path = file.path;
          String name = data.last.substring(0, data.last.length - 4);
          Song song = Song(path: path, name: name);

          songList.add(song);
        }
      }
    }
    setState(() {});
  }

  Future<void> retrieveDirectories() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey(prefsKey) == false) {
      return;
    }
    List<String>? stringList = prefs.getStringList(prefsKey);

    if (stringList == null) {
      return;
    }

    directories = stringList;
  }

  Future<void> saveDirectories() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(prefsKey, directories);
  }

  Future<void> checkPermission() async {
    if (io.Platform.isAndroid == false) {
      return;
    }

    if (await Permission.manageExternalStorage.isGranted == false) {
      Permission.manageExternalStorage.request();
    }
  }
}
