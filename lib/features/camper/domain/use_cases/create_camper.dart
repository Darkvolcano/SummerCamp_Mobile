import 'package:summercamp/features/camper/domain/entities/camper.dart';
import 'package:summercamp/features/camper/domain/repositories/camper_repository.dart';

class CreateCamper {
  final CamperRepository repository;
  CreateCamper(this.repository);

  Future<void> call(Camper camper) async {
    await repository.createCamper(camper);
  }
}
