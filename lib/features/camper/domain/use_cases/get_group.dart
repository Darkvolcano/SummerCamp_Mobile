import 'package:summercamp/features/camper/domain/entities/group.dart';
import 'package:summercamp/features/camper/domain/repositories/camper_repository.dart';

class GetCampGroup {
  final CamperRepository repository;

  GetCampGroup(this.repository);

  Future<Group> call(int campId) {
    return repository.getCampGroup(campId);
  }
}
