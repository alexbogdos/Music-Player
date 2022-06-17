import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_player/classes/song.dart';
import 'package:music_player/widgets/control_bar.dart';
import 'package:music_player/widgets/song_preview.dart';

// ignore: must_be_immutable
class CPlayer extends StatefulWidget {
  CPlayer({
    required this.song,
    required this.width,
    required this.isCollapsed,
    required this.isPlaying,
    required this.position,
    required this.duration,
    required this.changePlayingState,
    required this.changeProgress,
    required this.player,
    Key? key,
  }) : super(key: key);

  Song song;
  double width;
  bool isCollapsed;
  bool isPlaying;
  Duration? position;
  Duration? duration;
  Function changePlayingState;
  Function changeProgress;
  AudioPlayer player;

  @override
  State<CPlayer> createState() => _CPlayerState();
}

class _CPlayerState extends State<CPlayer> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: 712,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SongPreview(
            song: widget.song,
          ),
          ControlBar(
            width: widget.width,
            isCollapsed: widget.isCollapsed,
            song: widget.song,
            position: widget.position,
            duration: widget.duration,
            isPlaying: widget.isPlaying,
            changePlayingState: widget.changePlayingState,
            changeProgress: widget.changeProgress,
            player: widget.player,
          )
        ],
      ),
    );
  }
}
