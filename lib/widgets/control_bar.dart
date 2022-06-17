import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_player/classes/song.dart';
import 'package:music_player/widgets/control_button.dart';
import 'package:music_player/widgets/slider.dart';

// ignore: must_be_immutable
class ControlBar extends StatefulWidget {
  const ControlBar({
    required this.width,
    required this.isCollapsed,
    required this.song,
    required this.position,
    required this.duration,
    required this.isPlaying,
    required this.changePlayingState,
    required this.changeProgress,
    required this.player,
    Key? key,
  }) : super(key: key);

  final double width;
  final bool isCollapsed;
  final Song song;
  final Duration? position;
  final Duration? duration;
  final bool isPlaying;
  final Function changePlayingState;
  final Function changeProgress;
  final AudioPlayer player;

  @override
  State<ControlBar> createState() => _ControlBarState();
}

class _ControlBarState extends State<ControlBar> {
  String getDuration(String duration) {
    if (duration == '-') {
      return duration;
    }

    int val = int.parse(duration);
    if (val >= 60) {
      val = val % 60;
    }
    duration = '';
    if (val < 10) {
      duration = '0';
    }
    duration += val.toString();

    if (duration.length > 2) {
      duration = duration.substring(0, 2);
    }

    return duration;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xFFECEDF5),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(63, 136, 157, 195),
            offset: Offset(0, -8),
            blurRadius: 16.0,
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: widget.isCollapsed
              ? const Radius.circular(40)
              : const Radius.circular(0),
          topRight: const Radius.circular(40),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: widget.isCollapsed ? 30 : 15,
          vertical: 0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ControlButton(
              isPlaying: widget.isPlaying,
              changeState: widget.changePlayingState,
              duration: widget.duration?.inMilliseconds, //widget.song.duration,
            ),
            ProgressSlider(
              duration: widget.duration?.inMilliseconds, //widget.song.duration,
              position: widget.position?.inMilliseconds,
              isCollapsed: widget.isCollapsed,
              changeProgress: widget.changeProgress,
              player: widget.player,
            ),
            SizedBox(
              width: 130,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  // "${widget.progress.toStringAsFixed(2)}/${widget.song.duration.toStringAsFixed(2)}",
                  "${widget.position?.inMinutes ?? '-'}:${getDuration('${widget.position?.inSeconds ?? '-'}')}/${widget.duration?.inMinutes ?? '-'}:${getDuration('${widget.duration?.inSeconds ?? '-'}')}",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: const Color(0xFF51698C).withOpacity(0.8),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
