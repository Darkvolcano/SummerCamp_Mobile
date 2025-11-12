import 'package:summercamp/features/camper/domain/entities/camper.dart';
import 'package:summercamp/features/camper/domain/repositories/camper_repository.dart';

class GetCampersByCoreActivityId {
  final CamperRepository repository;
  GetCampersByCoreActivityId(this.repository);

  Future<List<Camper>> call(int coreActivityId) {
    return repository.getCampersByCoreActivityId(coreActivityId);
  }
}
