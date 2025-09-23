import 'package:summercamp/features/camper/domain/entities/camper.dart';
import 'package:summercamp/features/camper/domain/repositories/camper_repository.dart';

class UpdateCamper {
  final CamperRepository repository;
  UpdateCamper(this.repository);

  Future<void> call(int camperId, Camper camper) async {
    await repository.updateCamper(camperId, camper);
  }
}
