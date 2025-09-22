import 'package:summercamp/features/camper/data/models/camper_model.dart';
import 'package:summercamp/features/camper/data/services/camper_api_service.dart';
import 'package:summercamp/features/camper/domain/entities/camper.dart';
import 'package:summercamp/features/camper/domain/repositories/camper_repository.dart';

class CamperRepositoryImpl implements CamperRepository {
  final CamperApiService service;

  CamperRepositoryImpl(this.service);

  @override
  Future<List<Camper>> getCampers() async {
    final list = await service.fetchCampers();
    return list.map((e) => CamperModel.fromJson(e)).toList();
  }

  @override
  Future<void> createCamper(Camper camper) async {
    final model = CamperModel(
      id: camper.id,
      fullName: camper.fullName,
      dob: camper.dob,
      gender: camper.gender,
      healthRecordId: camper.healthRecordId,
      createAt: camper.createAt,
      parentId: camper.parentId,
    );
    await service.createCamper(model.toJson());
  }

  @override
  Future<void> updateCamper(int id, Camper camper) {
    throw UnimplementedError();
  }
}
