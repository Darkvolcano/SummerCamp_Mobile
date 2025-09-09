import 'package:summercamp/features/camp/domain/entities/camp.dart';
import 'package:summercamp/features/camp/domain/repositories/camp_repository.dart';

class GetCamps {
  final CampRepository repository;
  GetCamps(this.repository);

  Future<List<Camp>> call() async {
    return await repository.getCamps();
  }
}
