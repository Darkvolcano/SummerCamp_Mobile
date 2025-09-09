import '../entities/camp.dart';
import '../repositories/camp_repository.dart';

class CreateCamp {
  final CampRepository repository;
  CreateCamp(this.repository);

  Future<void> call(Camp camp) async {
    await repository.createCamp(camp);
  }
}
