class Livestream {
  final int livestreamId;
  final String? roomId;
  final String? title;
  final int? hostId;

  const Livestream({
    required this.livestreamId,
    this.roomId,
    this.title,
    this.hostId,
  });
}
