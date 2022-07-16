import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_music_player/widgets/folder_tile.dart';

class SettingsPanel extends StatelessWidget {
  const SettingsPanel({
    Key? key,
    required this.panelWidth,
    required this.panelHeight,
    required this.panelColor,
    required this.shadowColor,
    required this.blurRadius,
    required this.iconSize,
    required this.directories,
    required this.tileColor,
    required this.secondaryColor,
  }) : super(key: key);

  final double panelWidth;
  final double panelHeight;
  final Color panelColor;
  final Color shadowColor;
  final double blurRadius;
  final double iconSize;
  final List<String> directories;
  final Color tileColor;
  final Color secondaryColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: panelWidth,
      height: panelHeight,
      decoration: BoxDecoration(
        color: panelColor,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            offset: const Offset(8, 8),
            blurRadius: blurRadius,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: panelWidth * 0.94,
            height: panelHeight * 0.14,
            alignment: Alignment.bottomCenter,
            child: Text(
              "Your Folders",
              style: GoogleFonts.ubuntu(
                fontSize: iconSize * 0.8,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            width: panelWidth * 0.92,
            height: panelHeight * 0.82,
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1.78,
              children: List.generate(directories.length, (index) {
                return FolderTile(
                  directories: directories,
                  index: index,
                  panelWidth: panelWidth,
                  tileColor: tileColor,
                  secondaryColor: secondaryColor,
                  iconSize: iconSize,
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
