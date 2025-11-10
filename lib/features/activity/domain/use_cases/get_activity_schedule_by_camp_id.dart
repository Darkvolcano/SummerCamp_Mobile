import 'package:summercamp/features/activity/domain/entities/activity_schedule.dart';
import 'package:summercamp/features/activity/domain/repositories/activity_repository.dart';

class GetActivitySchedulesByCampId {
  final ActivityRepository repository;
  GetActivitySchedulesByCampId(this.repository);

  Future<List<ActivitySchedule>> call(int campId) async {
    return await repository.getActivitySchedulesByCampId(campId);
  }
}
