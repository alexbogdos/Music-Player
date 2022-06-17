import 'package:flutter/material.dart';

class Song {
  const Song(
      {required this.title,
      required this.path,
      this.artist,
      this.cover,
      Key? key});

  final String title;
  final String path;

  final String? artist;
  final ImageProvider<Object>? cover;
}
