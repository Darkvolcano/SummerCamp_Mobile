import 'package:summercamp/features/schedule/domain/entities/camper_transport.dart';
import 'package:summercamp/features/schedule/domain/entities/schedule.dart';
import 'package:summercamp/features/schedule/domain/entities/transport_schedule.dart';

abstract class ScheduleRepository {
  Future<List<Schedule>> getStaffSchedules();
  Future<void> updateTransportScheduleStartTrip(int id);
  Future<void> updateTransportScheduleEndTrip(int id);
  Future<List<TransportSchedule>> getDriverSchedules();
  Future<List<CamperTransport>> getCampersTransportByTransportScheduleId(
    int transportScheduleId,
  );
  Future<void> updateCamperTransportAttendanceCheckInList({
    required List<int> camperTransportIds,
    String? note,
  });
  Future<void> updateCamperTransportAttendanceCheckOutList({
    required List<int> camperTransportIds,
    String? note,
  });
  Future<List<TransportSchedule>> getStaffTransportSchedules();
}
