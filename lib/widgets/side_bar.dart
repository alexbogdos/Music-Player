import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SideBar extends StatefulWidget {
  SideBar({required this.notifyParent, Key? key}) : super(key: key);

  Function notifyParent;

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
    );
  }
}
