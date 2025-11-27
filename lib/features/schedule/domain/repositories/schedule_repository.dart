import 'package:summercamp/features/schedule/domain/entities/schedule.dart';
import 'package:summercamp/features/schedule/domain/entities/transport_schedule.dart';

abstract class ScheduleRepository {
  Future<List<Schedule>> getStaffSchedules();
  Future<void> updateTransportScheduleStartTrip(int id);
  Future<void> updateTransportScheduleEndTrip(int id);
  Future<List<TransportSchedule>> getDriverSchedules();
}
