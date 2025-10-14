import 'package:summercamp/features/activity/domain/entities/activity.dart';
import 'package:summercamp/features/activity/domain/repositories/activity_repository.dart';

class GetActivities {
  final ActivityRepository repository;
  GetActivities(this.repository);

  Future<List<Activity>> call() async {
    return await repository.getActivities();
  }
}
