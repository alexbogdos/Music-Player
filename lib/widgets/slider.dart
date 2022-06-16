import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ProgressSlider extends StatefulWidget {
  ProgressSlider({
    required this.isCollapsed,
    required this.duration,
    required this.progress,
    required this.changeProgress,
    Key? key,
  }) : super(key: key);

  bool isCollapsed;
  double duration;
  double progress;

  Function changeProgress;

  @override
  State<ProgressSlider> createState() => _ProgressSliderState();
}

class _ProgressSliderState extends State<ProgressSlider> {
  @override
  Widget build(BuildContext context) {
    double value = 0;
    if (widget.progress <= widget.duration) {
      value = widget.progress;
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
        max: widget.duration,
        value: value,
        activeColor: const Color(0xFF51698C),
        inactiveColor: const Color(0xFF51698C).withOpacity(0.4),
        onChanged: (val) {
          if (val <= widget.duration) {
            setState(() {
              widget.changeProgress(value: val);
            });
          }
        },
      ),
    );
  }
}
