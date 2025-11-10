import 'package:summercamp/features/activity/domain/entities/activity_schedule.dart';

abstract class ActivityRepository {
  Future<List<ActivitySchedule>> getActivitySchedulesByCampId(int campId);
  Future<List<ActivitySchedule>> getActivitySchedulesOptionalByCampId(
    int campId,
  );
  Future<List<ActivitySchedule>> getActivitySchedulesCoreByCampId(int campId);
}
