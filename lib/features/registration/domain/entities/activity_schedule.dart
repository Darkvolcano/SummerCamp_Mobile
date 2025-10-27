import 'package:summercamp/features/registration/domain/entities/activity.dart';

class ActivitySchedule {
  final int activityScheduleId;
  final Activity? activity;
  final int staffId;
  final DateTime startTime;
  final DateTime endTime;
  final String status;
  final bool isLivestream;
  final String? roomId;
  final int? maxCapacity;
  final bool isOptional;
  final int? locationId;
  final int? currentCapacity;

  const ActivitySchedule({
    required this.activityScheduleId,
    this.activity,
    required this.staffId,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.isLivestream,
    this.roomId,
    this.maxCapacity,
    required this.isOptional,
    this.locationId,
    this.currentCapacity,
  });
}
