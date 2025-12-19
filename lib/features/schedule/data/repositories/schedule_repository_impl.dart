import 'package:summercamp/features/schedule/data/models/camper_transport_model.dart';
import 'package:summercamp/features/schedule/data/models/route_model.dart';
import 'package:summercamp/features/schedule/data/models/schedule_model.dart';
import 'package:summercamp/features/schedule/data/models/transport_schedule_model.dart';
import 'package:summercamp/features/schedule/data/services/schedule_api_service.dart';
import 'package:summercamp/features/schedule/domain/entities/camper_transport.dart';
import 'package:summercamp/features/schedule/domain/entities/route.dart';
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

  @override
  Future<List<CamperTransport>> getCampersTransportByTransportScheduleId(
    int transportScheduleId,
  ) async {
    final list = await service.fetchCampersTransportByTransportScheduleId(
      transportScheduleId,
    );
    return list
        .map(
          (data) => CamperTransportModel.fromJson(data as Map<String, dynamic>),
        )
        .toList();
  }

  @override
  Future<void> updateCamperTransportAttendanceCheckInList({
    required List<int> camperTransportIds,
    String? note,
  }) async {
    await service.updateCampertransportAttendanceCheckIn(
      camperTransportIds: camperTransportIds,
      note: note,
    );
  }

  @override
  Future<void> updateCamperTransportAttendanceCheckOutList({
    required List<int> camperTransportIds,
    String? note,
  }) async {
    await service.updateCampertransportAttendanceCheckOut(
      camperTransportIds: camperTransportIds,
      note: note,
    );
  }

  @override
  Future<List<TransportSchedule>> getStaffTransportSchedules() async {
    final list = await service.fetchStaffTransportSchedules();
    return list.map((e) => TransportScheduleModel.fromJson(e)).toList();
  }

  @override
  Future<List<Route>> getRouteStopByRouteId(int routeId) async {
    final list = await service.fetchRouteStopByRouteId(routeId);
    return list
        .map((data) => RouteModel.fromJson(data as Map<String, dynamic>))
        .toList();
  }
}
