import 'package:summercamp/features/livestream/domain/entities/livestream.dart';

class LivestreamModel extends Livestream {
  const LivestreamModel({
    required super.livestreamId,
    super.roomId,
    super.title,
    super.hostId,
  });

  factory LivestreamModel.fromJson(Map<String, dynamic> json) {
    return LivestreamModel(
      livestreamId: json['livestreamId'],
      roomId: json['roomId'],
      title: json['title'],
      hostId: json['hostId'],
    );
  }

  Map<String, dynamic> toJson() => {
    'livestreamId': livestreamId,
    'roomId': roomId,
    'title': title,
    'hostId': hostId,
  };
}
