import 'package:summercamp/features/schedule/data/models/schedule_model.dart';
import 'package:summercamp/features/schedule/data/models/transport_schedule_model.dart';
import 'package:summercamp/features/schedule/data/services/schedule_api_service.dart';
import 'package:summercamp/features/schedule/domain/entities/schedule.dart';
import 'package:summercamp/features/schedule/domain/entities/transport_schedule.dart';
import 'package:summercamp/features/schedule/domain/repositories/schedule_repository.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleApiService service;
  ScheduleRepositoryImpl(this.service);

  @override
  Future<List<Schedule>> getStaffSchedules() async {
    final list = await service.fetchStaffSchedules();
    return list.map((e) => ScheduleModel.fromJson(e)).toList();
  }

  @override
  Future<void> updateTransportScheduleStartTrip(int id) async {
    await service.updateTransportScheduleStartTrip(id);
  }

  @override
  Future<void> updateTransportScheduleEndTrip(int id) async {
    await service.updateTransportScheduleEndTrip(id);
  }

  @override
  Future<List<TransportSchedule>> getDriverSchedules() async {
    final list = await service.fetchDriverSchedules();
    return list.map((e) => TransportScheduleModel.fromJson(e)).toList();
  }
}
