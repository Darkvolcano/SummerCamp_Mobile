import 'package:summercamp/features/activity/domain/entities/activity.dart';
import 'package:summercamp/features/activity/domain/entities/livestream.dart';
import 'package:summercamp/features/activity/domain/entities/staff.dart';

class ActivitySchedule {
  final int activityScheduleId;
  final Activity? activity;
  final Staff? staff;
  final DateTime startTime;
  final DateTime endTime;
  final String status;
  final bool isLivestream;
  final Livestream? liveStream;
  final int? maxCapacity;
  final bool isOptional;
  final int? locationId;
  final int? currentCapacity;

  const ActivitySchedule({
    required this.activityScheduleId,
    this.activity,
    this.staff,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.isLivestream,
    this.liveStream,
    this.maxCapacity,
    required this.isOptional,
    this.locationId,
    this.currentCapacity,
  });
}
