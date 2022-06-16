import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ControlButton extends StatelessWidget {
  const ControlButton({
    required this.isPlaying,
    required this.changeState,
    required this.duration,
    Key? key,
  }) : super(key: key);

  final bool isPlaying;
  final Function changeState;
  final double duration;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 40,
      // width: 40,
      child: TextButton(
        style: TextButton.styleFrom(
          primary: const Color(0xFFECEDF5),
          onSurface: Colors.transparent,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
        ),
        onPressed: () {
          if (duration > 0) {
            changeState();
          }
        },
        child: isPlaying
            ? Image.asset(
                'images/pause_button.png',
                width: 40,
                height: 40,
              )
            : Image.asset(
                'images/play_button.png',
                width: 40,
                height: 40,
              ),
      ),
    );
  }
}
