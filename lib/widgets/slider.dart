import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ProgressSlider extends StatefulWidget {
  ProgressSlider({
    required this.isCollapsed,
    required this.duration,
    required this.position,
    required this.player,
    required this.changeProgress,
    Key? key,
  }) : super(key: key);

  bool isCollapsed;
  int? duration;
  int? position;
  AudioPlayer player;

  Function changeProgress;

  @override
  State<ProgressSlider> createState() => _ProgressSliderState();
}

class _ProgressSliderState extends State<ProgressSlider> {
  @override
  Widget build(BuildContext context) {
    int value = 0;

    int dur = 0;
    if (widget.duration != null) {
      dur = widget.duration as int;
      if (widget.position != null) {
        if (widget.position as int <= dur) {
          value = widget.position as int;
        }
      }
    }
    double widgetWidth;

    if (widget.isCollapsed) {
      widgetWidth = 624;
    } else {
      widgetWidth = 436;
    }

    return SizedBox(
      width: widgetWidth,
      height: 8,
      child: Slider(
        max: dur.toDouble(),
        value: value.toDouble(),
        activeColor: const Color(0xFF51698C),
        inactiveColor: const Color(0xFF51698C).withOpacity(0.4),
        onChanged: (val) {
          if (val <= dur) {
            setState(() {
              widget.changeProgress(value: val);
            });
          }
        },
      ),
    );
  }
}
