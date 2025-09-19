import 'package:summercamp/features/camper/domain/entities/camper.dart';
import 'package:summercamp/features/camper/domain/repositories/camper_repository.dart';

class GetCampers {
  final CamperRepository repository;
  GetCampers(this.repository);

  Future<List<Camper>> call() async {
    return await repository.getCampers();
  }
}
