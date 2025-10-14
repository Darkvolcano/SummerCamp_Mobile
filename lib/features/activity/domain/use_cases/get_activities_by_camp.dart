import 'package:summercamp/features/activity/domain/entities/activity.dart';
import 'package:summercamp/features/activity/domain/repositories/activity_repository.dart';

class GetActivitiesByCampId {
  final ActivityRepository repository;

  GetActivitiesByCampId(this.repository);

  Future<List<Activity>> call(int campId) {
    return repository.getActivitiesByCampId(campId);
  }
}
