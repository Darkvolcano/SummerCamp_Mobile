import 'package:summercamp/features/camper/domain/entities/camper_group.dart';
import 'package:summercamp/features/camper/domain/repositories/camper_repository.dart';

class GetCamperGroupByGroupId {
  final CamperRepository repository;
  GetCamperGroupByGroupId(this.repository);

  Future<List<CamperGroup>> call(int groupId) {
    return repository.getCamperGroupId(groupId);
  }
}
