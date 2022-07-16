import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FolderTile extends StatelessWidget {
  const FolderTile({
    required this.directories,
    required this.index,
    required this.panelWidth,
    required this.tileColor,
    required this.secondaryColor,
    required this.iconSize,
    Key? key,
  }) : super(key: key);

  final List<String> directories;
  final int index;
  final double panelWidth;
  final Color tileColor;
  final Color secondaryColor;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: tileColor,
          borderRadius: BorderRadius.circular(35),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: (panelWidth * 0.92 - 24) * 0.45 * 0.34,
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.folder_rounded,
                color: secondaryColor,
                size: iconSize * 1.2,
              ),
            ),
            Container(
              width: (panelWidth * 0.92 - 24) * 0.45 * 0.66,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(right: 4),
              child: Text(
                getFolderName(directory: directories[index]),
                textAlign: TextAlign.center,
                style: GoogleFonts.ubuntu(
                  color: secondaryColor,
                  fontSize: iconSize * 0.46,
                ),
              ),
            ),
          ],
        ));
  }

  String getFolderName({required String directory}) {
    List<String> dir = directory.split("/");
    int count = dir.length - 1;
    return dir[count - 1];
  }
}
