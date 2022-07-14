class Song {
  const Song({
    required this.path,
    required this.name,
    this.artist = "Uknown",
  });

  final String path;
  final String name;
  final String? artist;
}
