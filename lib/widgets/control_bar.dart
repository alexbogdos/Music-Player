import 'package:flutter/material.dart';

class ControlBar extends StatefulWidget {
  ControlBar({required this.width, Key? key}) : super(key: key);

  double width;

  @override
  State<ControlBar> createState() => _ControlBarState();
}

class _ControlBarState extends State<ControlBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: 140,
      decoration: const BoxDecoration(
        color: Color(0xFFECEDF5),
      ),
    );
  }
}
