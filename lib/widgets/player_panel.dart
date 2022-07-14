import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'package:test_music_player/widgets/control_bar.dart';
import 'package:test_music_player/widgets/info_preview.dart';
import 'package:test_music_player/widgets/song.dart';

class PlayerPanel extends StatelessWidget {
  const PlayerPanel({
    Key? key,
    required this.width,
    required this.playerWidth,
    required this.playerHeight,
    required this.panelIsExtended,
    required this.logoSize,
    required this.panelColor,
    required this.shadowColor,
    required this.blurRadius,
    required this.secondaryColor,
    required this.songList,
    required this.currentSong,
    required this.player,
    required this.changePlayState,
    required this.isPlaying,
    required this.getPlayState,
    required this.checkCache,
    required this.doClearCache,
    required this.setIndex,
    required this.getIndex,
    required this.setSong,
  }) : super(key: key);

  final double width;
  final double playerWidth;
  final double playerHeight;
  final bool panelIsExtended;
  final double logoSize;
  final Color panelColor;
  final Color shadowColor;
  final double blurRadius;
  final Color secondaryColor;

  final List<Song> songList;
  final Song currentSong;
  final AudioPlayer player;
  final Function() changePlayState;
  final bool isPlaying;
  final Function getPlayState;
  final Function checkCache;
  final Function doClearCache;

  final Function({required int index}) setIndex;
  final Function getIndex;
  final Function({required Song song, bool play}) setSong;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: playerWidth,
      height: playerHeight,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InfoPreview(
            logoSize: logoSize,
            panelColor: panelColor,
            shadowColor: shadowColor,
            blurRadius: blurRadius,
            secondaryColor: secondaryColor,
            name: currentSong.name,
            artist: currentSong.artist,
          ),
          ControlBar(
            width: width,
            playerWidth: playerWidth,
            playerHeight: playerHeight,
            panelColor: panelColor,
            panelIsExtended: panelIsExtended,
            shadowColor: shadowColor,
            blurRadius: blurRadius,
            secondaryColor: secondaryColor,
            songList: songList,
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
        ],
      ),
    );
  }
}
