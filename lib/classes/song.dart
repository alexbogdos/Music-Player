import 'package:flutter/material.dart';

class Song {
  const Song(
      {required this.title,
      required this.artist,
      required this.path,
      this.cover,
      Key? key});

  final String title;
  final String artist;
  final String path;

  final ImageProvider<Object>? cover;
}
