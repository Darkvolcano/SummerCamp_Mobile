import 'package:summercamp/features/camp/domain/entities/camp.dart';
import 'package:summercamp/features/camp/domain/entities/camp_type.dart';

abstract class CampRepository {
  Future<List<Camp>> getCamps();
  Future<void> createCamp(Camp camp);
  Future<List<CampType>> getCampTypes();
}
