import 'dart:io';
import 'package:summercamp/features/attendance/domain/repositories/attendance_repository.dart';

class RecognizeFace {
  final AttendanceRepository repository;

  RecognizeFace(this.repository);

  Future<Map<String, dynamic>> call({
    required int activityScheduleId,
    required File photo,
    required int campId,
    required int groupId,
  }) {
    return repository.recognizeFace(
      activityScheduleId: activityScheduleId,
      photo: photo,
      campId: campId,
      groupId: groupId,
    );
  }
}
