import 'package:flutter/material.dart';
import 'package:music_player/classes/song.dart';
import 'package:music_player/widgets/song_tile.dart';

class SideBar extends StatefulWidget {
  const SideBar({
    required this.notifyParent,
    required this.playSong,
    required this.collapseView,
    required this.songs,
    required this.pickFile,
    Key? key,
  }) : super(key: key);

  final Function notifyParent;
  final Function playSong;
  final Function collapseView;
  final List<Song> songs;
  final Function pickFile;

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 712,
      decoration: BoxDecoration(
        color: const Color(0xFFECEDF5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF889DC3).withOpacity(0.25),
            offset: const Offset(8, 0),
            blurRadius: 16,
          )
        ],
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(40),
        ),
      ),
      child: Stack(
        children: [
          SizedBox(
            width: 300,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 0),
              child: Stack(
                children: [
                  const SizedBox(
                    width: 300,
                    child: Text(
                      "Your Songs",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF172329),
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      widget.collapseView();
                    },
                    icon: const Icon(
                      Icons.close_fullscreen_rounded,
                      color: Color(0xFF172329),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 712,
            width: 300,
            child: Padding(
              padding: const EdgeInsets.only(top: 80, left: 16, right: 16),
              child: ListView.builder(
                itemCount: widget.songs.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index < widget.songs.length) {
                    return SongTile(
                      song: widget.songs[index],
                      playSong: widget.playSong,
                    );
                  } else {
                    return Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        height: 60,
                        width: 220,
                        child: TextButton(
                          onPressed: () {
                            widget.pickFile();
                          },
                          style: TextButton.styleFrom(
                            backgroundColor:
                                const Color(0xFFCED2E6).withOpacity(0.4),
                            primary: const Color(0xFF51698C),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: const [
                              Icon(
                                Icons.open_in_new_rounded,
                                color: Color(
                                  0xFF172329,
                                ),
                              ),
                              Text(
                                "Choose Songs..",
                                style: TextStyle(
                                  color: Color(0xFF172329),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
