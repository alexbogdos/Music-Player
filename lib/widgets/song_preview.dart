import 'package:flutter/material.dart';
import 'package:music_player/classes/song.dart';

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
    return SizedBox(
      height: 440,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          width: 420,
          height: 340,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFECEDF5),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: getImage(song),
              ),
              const SizedBox(height: 15),
              Text(
                song.title,
                style: const TextStyle(
                  color: Color(0xFF172329),
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                song.artist == null ? "Uknown" : song.artist.toString(),
                style: TextStyle(
                  color: const Color(0xFF172329).withOpacity(0.9),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
