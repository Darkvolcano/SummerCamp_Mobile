import 'package:summercamp/features/activity/domain/entities/activity.dart';

class ActivityModel extends Activity {
  const ActivityModel({
    required super.activityId,
    required super.name,
    required super.description,
    required super.location,
    required super.startTime,
    required super.endTime,
    required super.campId,
    required super.isLivestream,
    super.roomId,
    super.staffId,
    required super.activityType,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      activityId: json['activityId'],
      name: json['name'],
      description: json['description'],
      location: json['location'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      campId: json['campId'],
      isLivestream: json['isLivestream'],
      roomId: json['roomId'],
      staffId: json['staffId'],
      activityType: json['activityType'],
    );
  }

  Map<String, dynamic> toJson() => {
    'activityId': activityId,
    'name': name,
    'description': description,
    'location': location,
    'startTime': startTime,
    'endTime': endTime,
    'campId': campId,
    'isLivestream': isLivestream,
    'roomId': roomId,
    'staffId': staffId,
    'activityType': activityType,
  };
}
