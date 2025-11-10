import 'package:summercamp/features/activity/data/models/activity_schedule_model.dart';
import 'package:summercamp/features/activity/data/services/activity_api_service.dart';
import 'package:summercamp/features/activity/domain/repositories/activity_repository.dart';
import 'package:summercamp/features/activity/domain/entities/activity_schedule.dart';

class ActivityRepositoryImpl implements ActivityRepository {
  final ActivityApiService service;

  ActivityRepositoryImpl(this.service);

  @override
  Future<List<ActivitySchedule>> getActivitySchedulesByCampId(
    int campId,
  ) async {
    final list = await service.fetchActivitySchedulesByCampId(campId);
    return list.map((e) => ActivityScheduleModel.fromJson(e)).toList();
  }

  @override
  Future<List<ActivitySchedule>> getActivitySchedulesOptionalByCampId(
    int campId,
  ) async {
    final list = await service.fetchActivitySchedulesOptionalByCampId(campId);
    return list.map((e) => ActivityScheduleModel.fromJson(e)).toList();
  }

  @override
  Future<List<ActivitySchedule>> getActivitySchedulesCoreByCampId(
    int campId,
  ) async {
    final list = await service.fetchActivitySchedulesCoreByCampId(campId);
    return list.map((e) => ActivityScheduleModel.fromJson(e)).toList();
  }
}
