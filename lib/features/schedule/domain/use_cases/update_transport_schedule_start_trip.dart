import 'package:summercamp/features/schedule/domain/repositories/schedule_repository.dart';

class UpdateTransportScheduleStartTrip {
  final ScheduleRepository repository;
  UpdateTransportScheduleStartTrip(this.repository);

  Future<void> call(int transportScheduleId) {
    return repository.updateTransportScheduleStartTrip(transportScheduleId);
  }
}
