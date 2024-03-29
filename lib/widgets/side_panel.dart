import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_music_player/widgets/song.dart';
import 'package:test_music_player/widgets/song_tile.dart';

class SidePanel extends StatelessWidget {
  const SidePanel({
    Key? key,
    required this.panelWidth,
    required this.height,
    required this.panelColor,
    required this.songList,
    required this.shadowColor,
    required this.blurRadius,
    required this.mainColor,
    required this.secondaryColor,
    required this.iconSize,
    required this.currentSong,
    required this.scrollController,
    required this.setSong,
    required this.getPlayState,
    required this.changePlayState,
    required this.scanDirectories,
    required this.setIndex,
  }) : super(key: key);

  final double panelWidth;
  final double height;
  final List<Song> songList;
  final Color panelColor;
  final Color shadowColor;
  final double blurRadius;
  final Color mainColor;
  final Color secondaryColor;
  final double iconSize;

  final Song currentSong;
  final ScrollController scrollController;
  final Function({required Song song, bool play}) setSong;
  final Function getPlayState;
  final Function changePlayState;
  final Function scanDirectories;
  final Function({required int index}) setIndex;

  @override
  Widget build(BuildContext context) {
    final double dividerHeight = max(min(height * 0.02, 20), 5);
    final double listHeight = height - 80 - 16 + (20 - dividerHeight);
    final double tilePadding = max(min(height * 0.0076, 8), 2);

    return Container(
      width: panelWidth,
      decoration: BoxDecoration(
        color: panelColor,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            offset: const Offset(8, 8),
            blurRadius: blurRadius,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 16, right: 4, left: 12),
        child: Column(
          children: [
            SizedBox(
              height: 60,
              width: panelWidth,
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      "Your Songs",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.ubuntu(
                        color: mainColor,
                        fontSize: iconSize * 0.8,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Align(
                    alignment: const Alignment(1, 1),
                    child: IconButton(
                      icon: const Icon(Icons.replay_rounded),
                      iconSize: iconSize,
                      color: mainColor,
                      splashColor: shadowColor.withOpacity(0.4),
                      focusColor: shadowColor.withOpacity(0.4),
                      hoverColor: shadowColor.withOpacity(0.2),
                      highlightColor: shadowColor.withOpacity(0.2),
                      onPressed: () {
                        scanDirectories();
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: dividerHeight),
            SizedBox(
              height: listHeight,
              child: Scrollbar(
                controller: scrollController,
                thumbVisibility: true,
                trackVisibility: false,
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: songList.length,
                  itemBuilder: (context, index) {
                    return File(songList[index].path).existsSync()
                        ? Padding(
                            padding:
                                EdgeInsets.only(bottom: tilePadding, right: 12),
                            child: SongTile(
                              width: panelWidth - 24,
                              pHeight: listHeight,
                              secondaryColor: secondaryColor,
                              panelColor: panelColor,
                              iconSize: iconSize,
                              song: songList[index],
                              isCurrentSong:
                                  currentSong.path == songList[index].path,
                              setSong: setSong,
                              getPlayState: getPlayState,
                              changePlayState: changePlayState,
                              index: index,
                              setIndex: setIndex,
                            ),
                          )
                        : const SizedBox.shrink();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
