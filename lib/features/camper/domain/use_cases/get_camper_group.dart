import 'package:summercamp/features/camper/domain/entities/camper_group.dart';
import 'package:summercamp/features/camper/domain/repositories/camper_repository.dart';

class GetCamperGroups {
  final CamperRepository repository;
  GetCamperGroups(this.repository);

  Future<List<CamperGroup>> call(int campId) {
    return repository.getCamperGroups(campId);
  }
}
