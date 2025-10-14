import 'package:summercamp/features/activity/domain/entities/activity.dart';

abstract class ActivityRepository {
  Future<List<Activity>> getActivities();
  Future<List<Activity>> getActivitiesByCampId(int campId);
}
