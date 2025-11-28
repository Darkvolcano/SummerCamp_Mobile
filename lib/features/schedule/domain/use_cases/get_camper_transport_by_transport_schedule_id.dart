import 'package:summercamp/features/schedule/domain/entities/camper_transport.dart';
import 'package:summercamp/features/schedule/domain/repositories/schedule_repository.dart';

class GetCampersTransportByTransportScheduleId {
  final ScheduleRepository repository;
  GetCampersTransportByTransportScheduleId(this.repository);

  Future<List<CamperTransport>> call(int transportScheduleId) {
    return repository.getCampersTransportByTransportScheduleId(
      transportScheduleId,
    );
  }
}
