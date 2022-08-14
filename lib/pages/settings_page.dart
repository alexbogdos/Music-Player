import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_music_player/widgets/settings_panel.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage(
      {required this.directories,
      required this.backgroundColor,
      required this.panelColor,
      required this.mainColor,
      required this.secondaryColor,
      required this.iconColor,
      required this.shadowColor,
      required this.blurRadius,
      required this.saveDirectories,
      Key? key})
      : super(key: key);

  final List<String> directories;
  final Color backgroundColor;
  final Color panelColor;
  final Color mainColor;
  final Color secondaryColor;
  final Color iconColor;
  final Color shadowColor;
  final double blurRadius;
  final Future<void> Function() saveDirectories;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    late double tPanelWidth = min(width * 0.56, 740);
    late double tPanelHeight = min(height * 0.7, 560);
    final double panelSize = max(min(tPanelWidth, tPanelHeight), 340);
    final double panelWidth = panelSize * 1.2;
    final double panelHeight = panelSize * 0.9;

    final double iconSize = max(min(width * 0.036, 35), 25);

    const Color tileColor = Color(0xFFCED2E6);

    return Scaffold(
      backgroundColor: widget.backgroundColor,
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SettingsPanel(
            panelWidth: panelWidth,
            panelHeight: panelHeight,
            panelColor: widget.panelColor,
            shadowColor: widget.shadowColor,
            blurRadius: widget.blurRadius,
            iconSize: iconSize,
            directories: widget.directories,
            tileColor: tileColor,
            secondaryColor: widget.secondaryColor,
            saveDirectories: widget.saveDirectories,
          ),
          SizedBox(height: panelHeight * 0.1),
          BottomButtons(
            panelWidth: panelWidth,
            panelHeight: panelHeight,
            panelColor: widget.panelColor,
            shadowColor: widget.shadowColor,
            blurRadius: widget.blurRadius,
            tileColor: tileColor,
            iconColor: widget.iconColor,
            iconSize: iconSize,
            notifyParent: refresh,
          ),
        ]),
      ),
    );
  }

  void refresh({required String directory}) {
    setState(() {
      widget.directories.add(directory);
      widget.saveDirectories();
    });
  }
}

class BottomButtons extends StatelessWidget {
  const BottomButtons({
    Key? key,
    required this.panelWidth,
    required this.panelHeight,
    required this.panelColor,
    required this.shadowColor,
    required this.blurRadius,
    required this.tileColor,
    required this.iconColor,
    required this.iconSize,
    required this.notifyParent,
  }) : super(key: key);

  final double panelWidth;
  final double panelHeight;
  final Color panelColor;
  final Color shadowColor;
  final double blurRadius;
  final Color tileColor;
  final Color iconColor;
  final double iconSize;
  final Function({required String directory}) notifyParent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: panelWidth,
      height: panelHeight * 0.26,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: panelColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            offset: const Offset(8, 8),
            blurRadius: blurRadius,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              selectFolder();
            },
            child: Container(
              width: (panelWidth - 12) * 0.495,
              height: (panelHeight * 0.26) - 10,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: tileColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
              ),
              child: Text(
                "Load Folder",
                style: GoogleFonts.ubuntu(
                  color: iconColor,
                  fontSize: iconSize * 0.68,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              width: (panelWidth - 12) * 0.495,
              height: (panelHeight * 0.26) - 10,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: tileColor,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Text(
                "Return",
                style: GoogleFonts.ubuntu(
                  color: iconColor,
                  fontSize: iconSize * 0.68,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> selectFolder() async {
    await FilePicker.platform.getDirectoryPath().then((value) {
      if (!(value == null)) {
        notifyParent(directory: value.toString());
      }
    });
  }
}
