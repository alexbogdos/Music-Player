import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_music_player/widgets/folder_tile.dart';

class SettingsPanel extends StatefulWidget {
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
    required this.saveDirectories,
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
  final Future<void> Function() saveDirectories;

  @override
  State<SettingsPanel> createState() => _SettingsPanelState();
}

class _SettingsPanelState extends State<SettingsPanel> {
  void removeDirectory({required int index}) {
    setState(() {
      widget.directories.removeAt(index);
      widget.saveDirectories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.panelWidth,
      height: widget.panelHeight,
      decoration: BoxDecoration(
        color: widget.panelColor,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: widget.shadowColor,
            offset: const Offset(8, 8),
            blurRadius: widget.blurRadius,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: widget.panelWidth * 0.94,
            height: widget.panelHeight * 0.14,
            alignment: Alignment.bottomCenter,
            child: Text(
              "Your Folders",
              style: GoogleFonts.ubuntu(
                fontSize: widget.iconSize * 0.8,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            width: widget.panelWidth * 0.92,
            height: widget.panelHeight * 0.82,
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1.78,
              children: List.generate(widget.directories.length, (index) {
                return FolderTile(
                  directories: widget.directories,
                  index: index,
                  panelWidth: widget.panelWidth,
                  tileColor: widget.tileColor,
                  secondaryColor: widget.secondaryColor,
                  iconSize: widget.iconSize,
                  notifyParent: removeDirectory,
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
