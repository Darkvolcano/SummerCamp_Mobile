import 'package:summercamp/features/schedule/domain/entities/schedule.dart';
import 'package:summercamp/features/schedule/domain/repositories/schedule_repository.dart';

class GetStaffSchedules {
  final ScheduleRepository repository;
  GetStaffSchedules(this.repository);

  Future<List<Schedule>> call() async {
    return await repository.getStaffSchedules();
  }
}
