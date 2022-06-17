import 'dart:async';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:music_player/classes/song.dart';
import 'package:music_player/widgets/player.dart';
import 'package:music_player/widgets/side_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AudioPlayer player = AudioPlayer();

  Duration? position, duration;
  late List<StreamSubscription> streams;

  Duration? streamDuration, streamPosition;
  PlayerState? state;

  @override
  void initState() {
    super.initState();
    retrieveSongs().then((value) => refresh());
    streams = <StreamSubscription>[
      player.onDurationChanged
          .listen((it) => setState(() => streamDuration = it)),
      player.onPlayerStateChanged.listen((it) => setState(() => state = it)),
      player.onPositionChanged
          .listen((it) => setState(() => streamPosition = it)),
      player.onPlayerComplete.listen((it) => playerComplete()),
      player.onSeekComplete.listen((it) => log('Seek complete!')),
    ];
  }

  @override
  void dispose() {
    super.dispose();
    for (var it in streams) {
      it.cancel();
    }
  }

  Future<void> playerComplete() async {
    isPlaying = false;
    log('Player complete!');
    position = const Duration(milliseconds: 0);

    await Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {});
    });
  }

  Future<void> getPosition() async {
    final pos = await player.getCurrentPosition();
    position = pos;
  }

  Future<void> getDuration() async {
    final dur = await player.getDuration();
    // setState(() {
    duration = dur;
    // });
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: true,
    );

    if (result != null) {
      for (int i = 0; i < result.count; i++) {
        PlatformFile file = result.files[i];

        bool found = false;
        for (Song song in songs) {
          if (file.path.toString() == song.path) {
            found = true;
            break;
          }
        }
        if (found == false) {
          setState(
            () {
              songs.add(
                Song(
                  title: file.name.substring(0, file.name.length - 4),
                  path: file.path.toString(),
                ),
              );
            },
          );
        }
      }
    }
  }

  Future<void> saveSongs() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> list = [];
    for (Song s in songs) {
      String data = "";
      data += "${s.title}, ";
      data += "${s.path}, ";
      if (s.artist != null) {
        data += "${s.artist}";
      }
      list.add(data);
    }

    prefs.setStringList('songs', list);
  }

  Future<void> retrieveSongs() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('songs')) {
      final List<String>? list = prefs.getStringList('songs');
      if (list != null) {
        songs.clear();
        for (String s in list) {
          List<String> data = s.split(', ');
          Song song;
          if (data.length == 3) {
            song = Song(title: data[0], path: data[1]);
          } else {
            song = Song(title: data[0], path: data[1], artist: data[2]);
          }
          songs.add(song);
        }
      }
    }
  }

  void refresh() {
    setState(() {});
  }

  Song currentSong = const Song(title: '', artist: '', path: '');

  Future<void> playSong({required Song song}) async {
    await player.stop();
    await player.release();
    // await player.setSource(DeviceFileSource(song.path));
    currentSong = song;
    isPlaying = true;

    await player.play(DeviceFileSource(song.path));

    // await getDuration();
    // await Future.delayed(const Duration(milliseconds: 200), () {
    //   setState(() {});
    // });

    // await getDuration();
    // await Future.delayed(const Duration(milliseconds: 200), () {
    //   setState(() {});
    // });
    // await Future.delayed(const Duration(seconds: 5), () {
    //   setState(() {});
    // });
  }

  void changePlayingState() {
    setState(() {
      isPlaying = !isPlaying;
      if (isPlaying) {
        player.resume();
        if (position?.inMilliseconds as int > 0) {
          player.seek(position!);
        }
      } else {
        player.pause();
      }
    });
  }

  void collapseView() {
    setState(() {
      isCollapsed = !isCollapsed;
    });
  }

  void changeProgress({required double value}) {
    setState(() {
      position = Duration(milliseconds: value.toInt());
      player.seek(position as Duration);
    });
  }

  bool isCollapsed = false;
  bool isPlaying = false;

  List<Song> songs = [
    const Song(
      title: 'I Am Love',
      artist: 'Alex Bogdos',
      path: '',
    ),
    const Song(
      title: 'Bottom of a Bottle',
      artist: 'Funky Geezer Music',
      path: '',
    ),
    // const Song(
    //   title: 'Who is She?',
    //   artist: 'Cockroach',
    //   path: '',
    // ),
  ];

  @override
  Widget build(BuildContext context) {
    if (isPlaying) {
      try {
        getDuration();
      } catch (e) {
        log(e.toString());
      }
      try {
        getPosition();
      } catch (e) {
        log(e.toString());
      }
    }
    return Scaffold(
      backgroundColor: const Color(0xFFB6BFDA),
      body: SafeArea(
        child: isCollapsed
            ? FittedBox(
                child: Stack(
                  children: [
                    CPlayer(
                      song: currentSong,
                      width: 1000,
                      isCollapsed: isCollapsed,
                      isPlaying: isPlaying,
                      duration: duration,
                      position: position,
                      changePlayingState: changePlayingState,
                      changeProgress: changeProgress,
                      player: player,
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            collapseView();
                            // songs.clear();
                            // saveSongs();
                          });
                        },
                        icon: const Icon(Icons.open_in_full_rounded,
                            color: Color(0xFF172329)))
                  ],
                ),
              )
            : FittedBox(
                child: Stack(
                  children: [
                    SizedBox(
                      width: 1000,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: CPlayer(
                          song: currentSong,
                          width: 700,
                          isCollapsed: isCollapsed,
                          isPlaying: isPlaying,
                          duration: duration,
                          position: position,
                          changePlayingState: changePlayingState,
                          changeProgress: changeProgress,
                          player: player,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SideBar(
                        notifyParent: refresh,
                        playSong: playSong,
                        collapseView: collapseView,
                        songs: songs,
                        pickFile: pickFile,
                        saveSongs: saveSongs,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
