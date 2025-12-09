import 'package:summercamp/features/schedule/domain/entities/transport_schedule.dart';
import 'package:summercamp/features/schedule/domain/repositories/schedule_repository.dart';

class GetStaffTransportSchedule {
  final ScheduleRepository repository;
  GetStaffTransportSchedule(this.repository);

  Future<List<TransportSchedule>> call() async {
    return await repository.getStaffTransportSchedules();
  }
}
