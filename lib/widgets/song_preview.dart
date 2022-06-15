import 'package:flutter/material.dart';
import 'package:temp/classes/song.dart';

// ignore: must_be_immutable
class SongPreview extends StatelessWidget {
  SongPreview({required this.song, Key? key}) : super(key: key);

  Song song;

  Image getImage(Song song) {
    if (song.cover != null) {
      ImageProvider<Object> cover = song.cover as ImageProvider<Object>;
      return Image(image: cover);
    } else {
      return Image.asset(
        "images/placeholder.png",
        width: 240,
        height: 240,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      height: 440,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          // color: Colors.amber,
          width: 420,
          height: 340,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFECEDF5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: getImage(song),
              ),
              Text(song.title),
              Text(song.author),
            ],
          ),
        ),
      ),
    );
  }
}
