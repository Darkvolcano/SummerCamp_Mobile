import '../entities/camp.dart';

abstract class CampRepository {
  Future<List<Camp>> getCamps();
  Future<void> createCamp(Camp camp);
}
