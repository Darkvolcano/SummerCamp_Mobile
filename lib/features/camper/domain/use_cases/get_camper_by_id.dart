import 'package:summercamp/features/camper/domain/entities/camper.dart';
import 'package:summercamp/features/camper/domain/repositories/camper_repository.dart';

class GetCamperById {
  final CamperRepository repository;
  GetCamperById(this.repository);

  Future<Camper> call(int camperId) async {
    return await repository.getCamperById(camperId);
  }
}
