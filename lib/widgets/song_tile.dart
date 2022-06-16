import 'package:flutter/material.dart';
import 'package:music_player/classes/song.dart';

class SongTile extends StatefulWidget {
  const SongTile({
    required this.song,
    required this.playSong,
    Key? key,
  }) : super(key: key);

  final Song song;
  final Function playSong;

  @override
  State<SongTile> createState() => _SongTileState();
}

class _SongTileState extends State<SongTile> {
  ImageProvider<Object> getImageProvider(Song song) {
    if (song.cover != null) {
      ImageProvider<Object> cover = song.cover as ImageProvider<Object>;
      return cover;
    } else {
      return const AssetImage(
        "images/placeholder.png",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.playSong(song: widget.song);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.only(left: 14),
        height: 100,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFCED2E6),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              foregroundImage: getImageProvider(widget.song),
              backgroundColor: const Color(0xFF51698C).withOpacity(0.4),
              radius: 30,
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 10, right: 8),
              width: 182,
              height: 600,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.song.title,
                    maxLines: 2,
                    style: const TextStyle(
                      color: Color(0xFF51698C),
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.song.artist,
                    maxLines: 2,
                    style: TextStyle(
                      color: const Color(0xFF51698C).withOpacity(0.8),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
