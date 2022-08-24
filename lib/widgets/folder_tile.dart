import 'dart:io' as io;

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
    required this.notifyParent,
    Key? key,
  }) : super(key: key);

  final List<String> directories;
  final int index;
  final double panelWidth;
  final Color tileColor;
  final Color secondaryColor;
  final double iconSize;
  final Function({required int index}) notifyParent;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: tileColor,
          borderRadius: BorderRadius.circular(35),
        ),
        child: Stack(
          children: [
            Row(
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
            ),
            Align(
              alignment: const Alignment(0.9, -0.88),
              child: IconButton(
                icon: Icon(
                  Icons.delete_forever_rounded,
                  size: iconSize,
                  color: Colors.red.shade600.withOpacity(0.6),
                ),
                onPressed: () {
                  notifyParent(index: index);
                },
              ),
            ),
          ],
        ));
  }

  String getFolderName({required String directory}) {
    String slash = '/';
    if (io.Platform.isWindows) 
    {
      slash = '\\';
    }
    List<String> dir = directory.split(slash);

    return dir.last;
  }
}
