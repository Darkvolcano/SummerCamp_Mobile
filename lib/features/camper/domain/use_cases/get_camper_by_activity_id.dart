import 'package:summercamp/features/camper/domain/entities/camper.dart';
import 'package:summercamp/features/camper/domain/repositories/camper_repository.dart';

class GetCampersByActivityId {
  final CamperRepository repository;
  GetCampersByActivityId(this.repository);

  Future<List<Camper>> call(int activityScheduleId) {
    return repository.getCampersByActivityId(activityScheduleId);
  }
}
