import 'package:summercamp/features/schedule/domain/repositories/schedule_repository.dart';

class UpdateCamperTransportAttendanceListCheckOut {
  final ScheduleRepository repository;
  UpdateCamperTransportAttendanceListCheckOut(this.repository);

  Future<void> call({required List<int> camperTransportIds, String? note}) {
    return repository.updateCamperTransportAttendanceCheckOutList(
      camperTransportIds: camperTransportIds,
      note: note,
    );
  }
}
