import 'dart:io';

import 'package:summercamp/features/camper/data/models/camper_group_model.dart';
import 'package:summercamp/features/camper/data/models/camper_model.dart';
import 'package:summercamp/features/camper/data/models/group_model.dart';
import 'package:summercamp/features/camper/data/models/health_record_model.dart';
import 'package:summercamp/features/camper/data/services/camper_api_service.dart';
import 'package:summercamp/features/camper/domain/entities/camper.dart';
import 'package:summercamp/features/camper/domain/entities/camper_group.dart';
import 'package:summercamp/features/camper/domain/entities/group.dart';
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
      camperName: camper.camperName,
      dob: camper.dob,
      gender: camper.gender,
      age: camper.age,
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
      camperName: camper.camperName,
      dob: camper.dob,
      gender: camper.gender,
      age: camper.age,
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
  Future<List<CamperGroup>> getCamperGroups(int campId) async {
    final list = await service.getCamperGroupsByCampId(campId);
    return list.map((e) => CamperGroupModel.fromJson(e)).toList();
  }

  @override
  Future<Group> getCampGroup(int campId) async {
    final data = await service.getCampGroup(campId);
    return GroupModel.fromJson(data);
  }

  @override
  Future<List<Camper>> getCampersByCoreActivityId(int coreActivityId) async {
    final list = await service.fetchCampersByCoreActivity(coreActivityId);
    return list
        .map((data) => CamperModel.fromJson(data as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<Camper>> getCampersByOptionalActivityId(
    int optionalActivityId,
  ) async {
    final list = await service.fetchCampersByOptionalActivity(
      optionalActivityId,
    );
    return list
        .map((data) => CamperModel.fromJson(data as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> updateUploadAvatarCamper(int camperId, File imageFile) async {
    await service.updateUploadAvatarCamper(camperId, imageFile);
  }
}
