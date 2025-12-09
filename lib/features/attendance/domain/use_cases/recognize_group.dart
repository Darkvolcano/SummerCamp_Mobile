import 'dart:io';
import 'package:summercamp/features/attendance/domain/repositories/attendance_repository.dart';

class RecognizeGroup {
  final AttendanceRepository repository;

  RecognizeGroup(this.repository);

  Future<Map<String, dynamic>> call({
    required int activityScheduleId,
    required File photo,
    required int campId,
    required int groupId,
  }) async {
    return await repository.recognizeGroup(
      activityScheduleId: activityScheduleId,
      photo: photo,
      campId: campId,
      groupId: groupId,
    );
  }
}
