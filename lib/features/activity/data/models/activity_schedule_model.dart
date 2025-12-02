import 'package:summercamp/features/activity/domain/entities/activity.dart';
import 'package:summercamp/features/activity/domain/entities/activity_schedule.dart';
import 'package:summercamp/features/activity/domain/entities/livestream.dart';
import 'package:summercamp/features/activity/domain/entities/staff.dart';

class ActivityScheduleModel extends ActivitySchedule {
  const ActivityScheduleModel({
    required super.activityScheduleId,
    super.activity,
    super.staff,
    required super.startTime,
    required super.endTime,
    required super.status,
    required super.isLivestream,
    super.liveStream,
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

    final staffData = json['staff'];
    Staff? staff;
    if (staffData != null && staffData is Map<String, dynamic>) {
      staff = Staff.fromJson(staffData);
    }

    final liveStreamData = json['liveStream'];
    Livestream? liveStream;
    if (liveStreamData != null && liveStreamData is Map<String, dynamic>) {
      liveStream = Livestream.fromJson(liveStreamData);
    }

    return ActivityScheduleModel(
      activityScheduleId: json['activityScheduleId'],
      activity: activity,
      staff: staff,
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      status: json['status'],
      isLivestream: json['isLivestream'],
      liveStream: liveStream,
      maxCapacity: json['maxCapacity'] as int?,
      isOptional: json['isOptional'],
      locationId: json['locationId'] as int?,
      currentCapacity: json['currentCapacity'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'activityScheduleId': activityScheduleId,
    'activity': activity?.toJson(),
    'staff': staff?.toJson(),
    'startTime': startTime.toIso8601String(),
    'endTime': endTime.toIso8601String(),
    'status': status,
    'isLivestream': isLivestream,
    'liveStream': liveStream?.toJson(),
    'maxCapacity': maxCapacity,
    'isOptional': isOptional,
    'locationId': locationId,
    'currentCapacity': currentCapacity,
  };
}
