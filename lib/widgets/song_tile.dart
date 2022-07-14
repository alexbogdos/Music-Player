import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_music_player/widgets/song.dart';

class SongTile extends StatelessWidget {
  const SongTile({
    required this.width,
    required this.secondaryColor,
    required this.panelColor,
    required this.iconSize,
    required this.song,
    required this.isCurrentSong,
    required this.setSong,
    required this.getPlayState,
    required this.changePlayState,
    required this.index,
    required this.setIndex,
    Key? key,
  }) : super(key: key);

  final double width;
  final Color secondaryColor;
  final Color panelColor;
  final double iconSize;

  final Song song;
  final bool isCurrentSong;
  final Function({required Song song, bool play}) setSong;
  final Function getPlayState;
  final Function changePlayState;

  final int index;
  final Function({required int index}) setIndex;

  @override
  Widget build(BuildContext context) {
    final String name = song.name;
    final String? artist = song.artist;

    const String defaultImageSrc = "assets/images/placeholder.png";
    const ImageProvider defaultImage = AssetImage(defaultImageSrc);

    const double height = 110;

    const Color tileColor = Color(0xFFCED2E6);

    final Color borderColor = isCurrentSong ? Colors.white : panelColor;

    return InkWell(
      onTap: () {
        if (isCurrentSong == false) {
          setSong(song: song, play: true);
          setIndex(index: index);
        } else {
          if (getPlayState() == false) {
            changePlayState();
          }
        }
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: tileColor,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            width: 3.6,
            color: borderColor,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: width * 0.22,
              padding: EdgeInsets.only(left: width * 0.04),
              child: CircleAvatar(
                backgroundImage: defaultImage,
                backgroundColor: secondaryColor.withOpacity(0.4),
                radius: iconSize * 0.9,
              ),
            ),
            SizedBox(
              width: width * 0.74 - 14,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: width * 0.74 - 16,
                    height: height * 0.48,
                    padding: const EdgeInsets.only(top: 8, right: 8),
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      name,
                      style: GoogleFonts.ubuntu(
                        fontSize: iconSize * 0.46,
                        fontWeight: FontWeight.w500,
                        color: secondaryColor,
                      ),
                    ),
                  ),
                  Container(
                    width: width * 0.74 - 16,
                    height: height * 0.44 - 3.6,
                    padding: const EdgeInsets.only(top: 4),
                    alignment: Alignment.topLeft,
                    child: Text(
                      artist.toString(),
                      style: GoogleFonts.ubuntu(
                        fontSize: iconSize * 0.38,
                        fontWeight: FontWeight.w400,
                        color: secondaryColor.withOpacity(0.8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
