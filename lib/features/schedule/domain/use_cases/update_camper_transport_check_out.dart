import 'package:summercamp/features/schedule/domain/entities/update_camper_transport.dart';
import 'package:summercamp/features/schedule/domain/repositories/schedule_repository.dart';

class UpdateCamperTransportAttendanceListCheckOut {
  final ScheduleRepository repository;
  UpdateCamperTransportAttendanceListCheckOut(this.repository);

  Future<void> call(List<UpdateCamperTransport> requests) {
    return repository.updateCamperTransportAttendanceCheckOutList(requests);
  }
}
