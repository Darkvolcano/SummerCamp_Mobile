import 'package:summercamp/features/schedule/domain/repositories/schedule_repository.dart';

class UpdateTransportScheduleEndTrip {
  final ScheduleRepository repository;
  UpdateTransportScheduleEndTrip(this.repository);

  Future<void> call(int transportScheduleId) {
    return repository.updateTransportScheduleEndTrip(transportScheduleId);
  }
}
