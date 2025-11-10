import 'package:summercamp/features/schedule/domain/entities/schedule.dart';

abstract class ScheduleRepository {
  Future<List<Schedule>> getSchedules();
}
