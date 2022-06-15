import 'package:flutter/material.dart';
import 'package:temp/classes/song.dart';
import 'package:temp/widgets/control_bar.dart';
import 'package:temp/widgets/song_preview.dart';

// ignore: must_be_immutable
class Player extends StatefulWidget {
  Player({
    required this.width,
    required this.notifyParent,
    Key? key,
  }) : super(key: key);

  double width;
  Function notifyParent;

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  Song song = Song(title: "I Am Love", author: "Alex Bogdos");

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
            song: song,
          ),
          ControlBar(
            width: widget.width,
          )
        ],
      ),
    );
  }
}
