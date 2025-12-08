class Livestream {
  final int livestreamId;
  final String? roomId;

  const Livestream({required this.livestreamId, this.roomId});

  factory Livestream.fromJson(Map<String, dynamic> json) {
    return Livestream(
      livestreamId: json['livestreamId'],
      roomId: json['roomId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'livestreamId': livestreamId, 'roomId': roomId};
  }
}
