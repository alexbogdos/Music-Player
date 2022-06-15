import 'package:flutter/material.dart';

class Song {
  Song({required this.title, required this.author, this.cover, Key? key});

  String title;
  String author;
  ImageProvider<Object>? cover;
}
