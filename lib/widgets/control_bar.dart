import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_music_player/widgets/song.dart';

class ControlBar extends StatefulWidget {
  const ControlBar({
    Key? key,
    required this.width,
    required this.playerWidth,
    required this.playerHeight,
    required this.panelColor,
    required this.panelIsExtended,
    required this.shadowColor,
    required this.blurRadius,
    required this.secondaryColor,
    required this.songList,
    required this.player,
    required this.changePlayState,
    required this.isPlaying,
    required this.getPlayState,
    required this.checkCache,
    required this.doClearCache,
    required this.setIndex,
    required this.getIndex,
    required this.setSong,
  }) : super(key: key);

  final double width;
  final double playerWidth;
  final double playerHeight;
  final Color panelColor;
  final bool panelIsExtended;
  final Color shadowColor;
  final double blurRadius;
  final Color secondaryColor;

  final List<Song> songList;
  final AudioPlayer player;
  final Function changePlayState;
  final bool isPlaying;
  final Function getPlayState;
  final Function checkCache;
  final Function doClearCache;

  final Function({required int index}) setIndex;
  final Function getIndex;
  final Function({required Song song, bool play}) setSong;

  @override
  State<ControlBar> createState() => _ControlBarState();
}

class _ControlBarState extends State<ControlBar> {
  late bool isPlaying = widget.isPlaying;
  late double sliderPprogress = 0;
  late int songPprogress = 0;
  late int duration = 0;
  late int tempDuration = -1;
  late int divisions = 1;
  late bool songLoaded = false;
  late bool seeking = false;

  late List<StreamSubscription> streams;

  @override
  void initState() {
    super.initState();
    streams = <StreamSubscription>[
      widget.player.onDurationChanged
          .listen((it) => setState(() => getDuration())),
      widget.player.onPositionChanged
          .listen((it) => setState(() => changeProgress(it: it))),
      widget.player.onPlayerComplete.listen((it) => playerComplete()),
    ];
  }

  @override
  void dispose() {
    super.dispose();
    for (var it in streams) {
      it.cancel();
    }
  }

  Future<void> playerComplete() async {
    int nextIndex = widget.getIndex() + 1;
    if (nextIndex < widget.songList.length) {
      widget.setIndex(index: nextIndex);
      Song nextSong = widget.songList[nextIndex];
      widget.setSong(song: nextSong, play: true);
    } else {
      await widget.player.release();
      duration = 0;
      tempDuration = -1;
      sliderPprogress = 0;
      songPprogress = 0;
      widget.changePlayState();
    }
  }

  Future<void> changeProgress({required Duration it}) async {
    songPprogress = it.inMilliseconds;

    if (seeking == false && widget.getPlayState()) {
      setState(() {
        sliderPprogress = songPprogress.floorToDouble();
      });
    }
  }

  Future<void> getDuration() async {
    Duration? dur = await widget.player.getDuration();

    setState(() {
      if (dur != null) {
        duration = dur.inMilliseconds;
      } else {
        duration = 0;
      }
    });
  }

  Future<void> getPosition() async {
    Duration? pos = await widget.player.getCurrentPosition();

    setState(() {
      if (pos != null) {
        songPprogress = pos.inMilliseconds;
      } else {
        songPprogress = 0;
      }
    });
  }

  Future<void> seekAtPosition({required int position}) async {
    if (position > 0) {
      Duration dur = Duration(milliseconds: position);
      widget.player.seek(dur);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.checkCache() == true) {
      duration = 0;
      tempDuration = -1;
      sliderPprogress = 0;
      songPprogress = 0;
      widget.doClearCache();
    }

    final double barHeight = max(min(widget.playerHeight * 0.18, 140), 80);
    final double barWidth = widget.playerWidth - 16 * 2;

    final double textSize = max(min(widget.playerWidth * 0.024, 32), 12);

    final String buttonImageSrc = widget.getPlayState()
        ? "assets/images/pause_button.png"
        : "assets/images/play_button.png";

    if (duration > 0) {
      divisions = (duration / 1000).round();
    }

    if (widget.getPlayState() == true) {
      songLoaded = true;
    }

    if ((duration == 0 || tempDuration != duration) && songLoaded) {
      tempDuration = duration;
      getDuration();
    }

    return Container(
      width: widget.playerWidth,
      height: barHeight,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: widget.panelColor,
        borderRadius: widget.panelIsExtended == true
            ? const BorderRadius.only(
                topRight: Radius.circular(40),
              )
            : const BorderRadius.only(
                topRight: Radius.circular(40),
                topLeft: Radius.circular(40),
              ),
        boxShadow: [
          BoxShadow(
            color: widget.shadowColor.withOpacity(0.15),
            offset: const Offset(8, -8),
            blurRadius: widget.blurRadius,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: textSize * 2.6,
            width: barWidth * 0.16,
            alignment: Alignment.center,
            child: InkWell(
              onTap: () {
                if (songLoaded) {
                  setState(() {
                    isPlaying = !isPlaying;
                    widget.changePlayState();
                  });
                }
              },
              child: Image.asset(buttonImageSrc),
            ),
          ),
          SizedBox(
            height: barHeight,
            width: barWidth * 0.66,
            child: Slider(
              thumbColor: widget.secondaryColor,
              activeColor: widget.secondaryColor,
              inactiveColor: widget.secondaryColor.withOpacity(0.4),
              min: 0,
              max: duration * 1.0,
              divisions: divisions,
              value: sliderPprogress,
              onChanged: (value) {
                setState(() {
                  sliderPprogress = value;
                });
              },
              onChangeStart: ((value) {
                seeking = true;
              }),
              onChangeEnd: ((value) {
                seekAtPosition(position: value.floor());
                if (widget.getPlayState() == false && value > 0) {
                  widget.player.seek(Duration(microseconds: value.floor()));
                  widget.changePlayState();
                }
                seeking = false;
              }),
            ),
          ),
          Container(
            height: barHeight,
            width: barWidth * 0.18,
            alignment: Alignment.center,
            child: Text(
              "${parseMilliseconds(mil: sliderPprogress.floor())} / ${parseMilliseconds(mil: duration.floor())}",
              textAlign: TextAlign.center,
              style: GoogleFonts.ubuntu(
                color: widget.secondaryColor.withOpacity(0.9),
                fontSize: textSize,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String parseMilliseconds({required int mil}) {
  Duration dur = Duration(milliseconds: mil);

  int hours = dur.inHours;
  int minutes = dur.inMinutes;
  int seconds = dur.inSeconds;

  String strMinutes = "";
  String strSeconds = "";

  if (minutes >= 60) {
    minutes = minutes % 60;
  }
  if (minutes < 10 && hours > 0) {
    strMinutes += "0";
  }
  strMinutes += minutes.toString();

  if (seconds >= 60) {
    seconds = seconds % 60;
  }
  if (seconds < 10) {
    strSeconds += "0";
  }
  strSeconds += seconds.toString();

  String time = "";
  if (hours > 0) {
    time = "$hours:$strMinutes:$strSeconds";
  } else {
    time = "$strMinutes:$strSeconds";
  }

  return time;
}
