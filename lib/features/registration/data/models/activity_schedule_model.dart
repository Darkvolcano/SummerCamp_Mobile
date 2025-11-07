import 'package:summercamp/features/registration/domain/entities/activity.dart';
import 'package:summercamp/features/registration/domain/entities/activity_schedule.dart';

class ActivityScheduleModel extends ActivitySchedule {
  const ActivityScheduleModel({
    required super.activityScheduleId,
    super.activity,
    required super.staffId,
    required super.startTime,
    required super.endTime,
    required super.status,
    required super.isLivestream,
    super.roomId,
    super.maxCapacity,
    required super.isOptional,
    super.locationId,
    super.currentCapacity,
  });

  factory ActivityScheduleModel.fromJson(Map<String, dynamic> json) {
    final activityData = json['activity'];
    Activity? activity;
    if (activityData != null && activityData is Map<String, dynamic>) {
      activity = Activity.fromJson(activityData);
    }

    return ActivityScheduleModel(
      activityScheduleId: json['activityScheduleId'],
      activity: activity,
      staffId: json['staffId'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      status: json['status'],
      isLivestream: json['isLivestream'],
      roomId: json['roomId'],
      maxCapacity: json['maxCapacity'] as int?,
      isOptional: json['isOptional'],
      locationId: json['locationId'] as int?,
      currentCapacity: json['currentCapacity'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'activityScheduleId': activityScheduleId,
    'activity': activity?.toJson(),
    'staffId': staffId,
    'startTime': startTime.toIso8601String(),
    'endTime': endTime.toIso8601String(),
    'status': status,
    'isLivestream': isLivestream,
    'roomId': roomId,
    'maxCapacity': maxCapacity,
    'isOptional': isOptional,
    'locationId': locationId,
    'currentCapacity': currentCapacity,
  };
}
