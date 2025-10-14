import 'package:summercamp/features/activity/data/models/activity_model.dart';
import 'package:summercamp/features/activity/data/services/activity_api_service.dart';
import 'package:summercamp/features/activity/domain/entities/activity.dart';
import 'package:summercamp/features/activity/domain/repositories/activity_repository.dart';

class ActivityRepositoryImpl implements ActivityRepository {
  final ActivityApiService service;
  ActivityRepositoryImpl(this.service);

  @override
  Future<List<Activity>> getActivities() async {
    final list = await service.fetchActivities();
    return list.map((e) => ActivityModel.fromJson(e)).toList();
  }

  @override
  Future<List<Activity>> getActivitiesByCampId(int campId) async {
    final list = await service.fetchActivitiesByCampId(campId);
    return list.map((e) => ActivityModel.fromJson(e)).toList();
  }
}
