import '../entities/camp.dart';
import '../repositories/camp_repository.dart';

class GetCamps {
  final CampRepository repository;
  GetCamps(this.repository);

  Future<List<Camp>> call() async {
    return await repository.getCamps();
  }
}
