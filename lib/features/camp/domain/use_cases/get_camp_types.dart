import 'package:summercamp/features/camp/domain/entities/camp_type.dart';
import 'package:summercamp/features/camp/domain/repositories/camp_repository.dart';

class GetCampTypes {
  final CampRepository repository;
  GetCampTypes(this.repository);

  Future<List<CampType>> call() async {
    return await repository.getCampTypes();
  }
}
