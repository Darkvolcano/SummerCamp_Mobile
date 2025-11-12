import 'package:summercamp/features/camper/domain/entities/camper.dart';
import 'package:summercamp/features/camper/domain/entities/camper_group.dart';

abstract class CamperRepository {
  Future<List<Camper>> getCampers();
  Future<void> createCamper(Camper camper);
  Future<void> updateCamper(int camperId, Camper camper);
  Future<Camper> getCamperById(int camperId);
  Future<List<CamperGroup>> getCamperGroups();
  Future<List<Camper>> getCampersByCoreActivityId(int coreActivityId);
  Future<List<Camper>> getCampersByOptionalActivityId(int optionalActivityId);
}
