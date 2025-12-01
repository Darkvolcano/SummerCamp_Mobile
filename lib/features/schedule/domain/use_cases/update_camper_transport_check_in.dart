import 'package:summercamp/features/schedule/domain/repositories/schedule_repository.dart';

class UpdateCamperTransportAttendanceListCheckIn {
  final ScheduleRepository repository;
  UpdateCamperTransportAttendanceListCheckIn(this.repository);

  Future<void> call({
    required List<int> camperTransportIds,
    String? note,
  }) async {
    await repository.updateCamperTransportAttendanceCheckInList(
      camperTransportIds: camperTransportIds,
      note: note,
    );
  }
}
