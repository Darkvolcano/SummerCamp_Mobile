import 'package:summercamp/features/activity/domain/entities/activity_schedule.dart';
import 'package:summercamp/features/activity/domain/repositories/activity_repository.dart';

class GetActivitySchedulesCoreByCampId {
  final ActivityRepository repository;
  GetActivitySchedulesCoreByCampId(this.repository);

  Future<List<ActivitySchedule>> call(int campId) async {
    return await repository.getActivitySchedulesCoreByCampId(campId);
  }
}
