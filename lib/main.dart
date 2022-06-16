import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:music_player/classes/song.dart';
import 'package:music_player/widgets/player.dart';
import 'package:music_player/widgets/side_bar.dart';

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
  AudioPlayer player = AudioPlayer();

  void pickFile() async {
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
          setState(() {
            songs.add(Song(
                title: file.name.substring(0, file.name.length - 4),
                artist: 'Uknown',
                path: file.path.toString()));
          });
        }
      }
    }
  }

  void refresh() {
    setState(() {});
  }

  Song currentSong = const Song(title: '', artist: '', path: '');
  void playSong({required Song song}) {
    setState(() {
      currentSong = song;
      progress = 0.0;
      isPlaying = true;
    });
  }

  void changePlayingState() {
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void collapseView() {
    setState(() {
      isCollapsed = !isCollapsed;
    });
  }

  void changeProgress({required double value}) {
    setState(() {
      progress = value;
    });
  }

  bool isCollapsed = false;
  bool isPlaying = false;
  double progress = 0.0;

  List<Song> songs = const [
    Song(
      title: 'I Am Love',
      artist: 'Alex Bogdos',
      path: '',
    ),
    Song(
      title: 'Bottom of a Bottle Yeahh',
      artist: 'Funky Geezer Music',
      path: '',
    ),
    Song(
      title: 'Who is She?',
      artist: 'Cockroach',
      path: '',
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
                      progress: progress,
                      changePlayingState: changePlayingState,
                      changeProgress: changeProgress,
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            collapseView();
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
                          progress: progress,
                          changePlayingState: changePlayingState,
                          changeProgress: changeProgress,
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
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
