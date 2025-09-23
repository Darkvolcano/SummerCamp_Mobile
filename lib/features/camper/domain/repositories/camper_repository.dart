import 'package:summercamp/features/camper/domain/entities/camper.dart';

abstract class CamperRepository {
  Future<List<Camper>> getCampers();
  Future<void> createCamper(Camper camper);
  Future<void> updateCamper(int camperId, Camper camper);
}
