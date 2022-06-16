import 'package:flutter/material.dart';
import 'package:music_player/classes/song.dart';
import 'package:music_player/widgets/control_button.dart';
import 'package:music_player/widgets/slider.dart';

// ignore: must_be_immutable
class ControlBar extends StatefulWidget {
  ControlBar({
    required this.width,
    required this.isCollapsed,
    required this.song,
    required this.progress,
    required this.isPlaying,
    required this.changePlayingState,
    required this.changeProgress,
    Key? key,
  }) : super(key: key);

  double width;
  bool isCollapsed;
  Song song;
  double progress;
  bool isPlaying;
  Function changePlayingState;
  Function changeProgress;

  @override
  State<ControlBar> createState() => _ControlBarState();
}

class _ControlBarState extends State<ControlBar> {
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
              duration: 2, //widget.song.duration,
            ),
            ProgressSlider(
              duration: 2, //widget.song.duration,
              progress: widget.progress,
              isCollapsed: widget.isCollapsed,
              changeProgress: widget.changeProgress,
            ),
            SizedBox(
              width: 130,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  // "${widget.progress.toStringAsFixed(2)}/${widget.song.duration.toStringAsFixed(2)}",
                  "${widget.progress.toStringAsFixed(2)}/2.00",
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
