import 'package:summercamp/features/camper/data/models/camper_group_model.dart';
import 'package:summercamp/features/camper/data/models/camper_model.dart';
import 'package:summercamp/features/camper/data/models/health_record_model.dart';
import 'package:summercamp/features/camper/data/services/camper_api_service.dart';
import 'package:summercamp/features/camper/domain/entities/camper.dart';
import 'package:summercamp/features/camper/domain/entities/camper_group.dart';
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
    HealthRecordModel? healthRecordModel;
    if (camper.healthRecord != null) {
      healthRecordModel = HealthRecordModel(
        condition: camper.healthRecord!.condition,
        allergies: camper.healthRecord!.allergies,
        isAllergy: camper.healthRecord!.isAllergy,
        note: camper.healthRecord!.note,
      );
    }

    final camperModel = CamperModel(
      camperId: camper.camperId,
      fullName: camper.fullName,
      dob: camper.dob,
      gender: camper.gender,
      healthRecord: healthRecordModel,
      groupId: camper.groupId,
      avatar: camper.avatar,
    );

    final data = camperModel.toJson();
    await service.createCamper(data: data);
  }

  @override
  Future<void> updateCamper(int camperId, Camper camper) async {
    HealthRecordModel? healthRecordModel;
    if (camper.healthRecord != null) {
      healthRecordModel = HealthRecordModel(
        condition: camper.healthRecord!.condition,
        allergies: camper.healthRecord!.allergies,
        isAllergy: camper.healthRecord!.isAllergy,
        note: camper.healthRecord!.note,
      );
    }

    final camperModel = CamperModel(
      camperId: camper.camperId,
      fullName: camper.fullName,
      dob: camper.dob,
      gender: camper.gender,
      healthRecord: healthRecordModel,
      groupId: camper.groupId,
      avatar: camper.avatar,
    );

    final data = camperModel.toJson();

    await service.updateCamper(camperId, data);
  }

  @override
  Future<Camper> getCamperById(int camperId) async {
    final data = await service.fetchCamperById(camperId);
    return CamperModel.fromJson(data);
  }

  @override
  Future<List<CamperGroup>> getCamperGroups() async {
    final list = await service.fetchCamperGroups();
    return list.map((e) => CamperGroupModel.fromJson(e)).toList();
  }
}
