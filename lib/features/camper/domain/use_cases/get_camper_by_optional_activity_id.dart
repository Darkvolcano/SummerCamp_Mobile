import 'package:summercamp/features/camper/domain/entities/camper.dart';
import 'package:summercamp/features/camper/domain/repositories/camper_repository.dart';

class GetCampersByOptionalActivityId {
  final CamperRepository repository;
  GetCampersByOptionalActivityId(this.repository);

  Future<List<Camper>> call(int optionalActivityId) {
    return repository.getCampersByOptionalActivityId(optionalActivityId);
  }
}
