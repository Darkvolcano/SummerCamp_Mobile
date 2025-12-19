import 'dart:io';

import 'package:flutter/material.dart';
import 'package:summercamp/features/camper/data/models/camper_model.dart';
import 'package:summercamp/features/camper/domain/entities/camper.dart';
import 'package:summercamp/features/camper/domain/entities/camper_group.dart';
import 'package:summercamp/features/camper/domain/entities/group.dart';
import 'package:summercamp/features/camper/domain/use_cases/create_camper.dart';
import 'package:summercamp/features/camper/domain/use_cases/get_camper.dart';
import 'package:summercamp/features/camper/domain/use_cases/get_camper_by_activity_id.dart';
import 'package:summercamp/features/camper/domain/use_cases/get_camper_by_core_activity_id.dart';
import 'package:summercamp/features/camper/domain/use_cases/get_camper_by_group_id.dart';
import 'package:summercamp/features/camper/domain/use_cases/get_camper_by_id.dart';
import 'package:summercamp/features/camper/domain/use_cases/get_camper_by_optional_activity_id.dart';
import 'package:summercamp/features/camper/domain/use_cases/get_camper_group.dart';
import 'package:summercamp/features/camper/domain/use_cases/get_group.dart';
import 'package:summercamp/features/camper/domain/use_cases/update_camper.dart';
import 'package:summercamp/features/camper/domain/use_cases/update_upload_avatar_camper.dart';

class CamperProvider with ChangeNotifier {
  final CreateCamper createCamperUseCase;
  final GetCampers getCampersUseCase;
  final UpdateCamper updateCamperUseCase;
  final GetCamperById getCamperByIdUseCase;
  final GetCamperGroups getCamperGroupsUseCase;
  final GetCamperGroupByGroupId getCamperGroupByGroupIdUseCase;
  final GetCampersByCoreActivityId getCampersByCoreActivityIdUseCase;
  final GetCampersByOptionalActivityId getCampersByOptionalActivityIdUseCase;
  final GetCampersByActivityId getCampersByActivityIdUseCase;
  final GetCampGroup getCampGroupUseCase;
  final UpdateUploadAvatarCamper updateUploadAvatarCamperUseCase;

  CamperProvider(
    this.createCamperUseCase,
    this.getCampersUseCase,
    this.updateCamperUseCase,
    this.getCamperByIdUseCase,
    this.getCamperGroupsUseCase,
    this.getCamperGroupByGroupIdUseCase,
    this.getCampersByCoreActivityIdUseCase,
    this.getCampersByOptionalActivityIdUseCase,
    this.getCampersByActivityIdUseCase,
    this.getCampGroupUseCase,
    this.updateUploadAvatarCamperUseCase,
  );

  List<Camper> _campers = [];
  List<Camper> get campers => _campers;

  List<Camper> _campersCoreActivity = [];
  List<Camper> get campersCoreActivity => _campersCoreActivity;

  List<Camper> _campersOptionalActivity = [];
  List<Camper> get campersOptionalActivity => _campersOptionalActivity;

  List<Camper> _campersActivity = [];
  List<Camper> get campersActivity => _campersActivity;

  Camper? _selectedCamper;
  Camper? get selectedCamper => _selectedCamper;

  List<CamperGroup> _camperGroups = [];
  List<CamperGroup> get camperGroups => _camperGroups;

  List<CamperGroup> _groupMembers = [];
  List<CamperGroup> get groupMembers => _groupMembers;

  Group? _group;
  Group? get group => _group;

  bool _loading = false;
  bool get loading => _loading;
  String? _error;
  String? get error => _error;

  Future<void> loadCampers() async {
    _loading = true;
    notifyListeners();

    _campers = await getCampersUseCase();

    _loading = false;
    notifyListeners();
  }

  Future<void> createCamper(Camper camper) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final newCamperData = await createCamperUseCase(camper);

      return newCamperData;
    } catch (e) {
      _error = "Lỗi khi tạo camper: $e";
      print(_error);
      rethrow;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCamperById(int camperId) async {
    _loading = true;
    _selectedCamper = null;
    notifyListeners();

    try {
      _selectedCamper = await getCamperByIdUseCase(camperId);
      _error = null;
    } catch (e) {
      _error = "Lỗi khi tải chi tiết camper: $e";
      rethrow;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> updateCamper(int camperId, Camper camper) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      await updateCamperUseCase(camperId, camper);

      final index = _campers.indexWhere((c) => c.camperId == camperId);
      if (index != -1) {
        final oldCamper = _campers[index];

        final updatedModel = CamperModel(
          camperId: camper.camperId,
          camperName: camper.camperName,
          dob: camper.dob,
          gender: camper.gender,
          healthRecord: camper.healthRecord,
          groupId: camper.groupId,
          avatar: oldCamper.avatar,
          createAt: oldCamper.createAt,
        );

        _campers[index] = updatedModel;
      }

      if (_selectedCamper?.camperId == camperId) {
        _selectedCamper = camper;
      }
    } catch (e) {
      _error = "Lỗi khi cập nhật camper: $e";
      rethrow;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> loadCamperGroups(int campId) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _camperGroups = await getCamperGroupsUseCase(campId);
    } catch (e) {
      _error = e.toString();
      _camperGroups = [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> loadCamperGroupsByGroupId(int groupId) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _camperGroups = await getCamperGroupByGroupIdUseCase(groupId);
    } catch (e) {
      _error = e.toString();
      _camperGroups = [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> loadStaffCampGroup(int campId) async {
    _loading = true;
    _error = null;
    _group = null;
    _groupMembers = [];
    notifyListeners();

    try {
      _group = await getCampGroupUseCase(campId);

      if (_group != null) {
        _groupMembers = await getCamperGroupByGroupIdUseCase(_group!.groupId);
      }
    } catch (e) {
      _error = e.toString();
      print("Lỗi load staff camp group logic: $e");
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> loadCampersByCoreActivityId(int coreActivityId) async {
    _loading = true;
    notifyListeners();

    _campersCoreActivity = await getCampersByCoreActivityIdUseCase(
      coreActivityId,
    );

    _loading = false;
    notifyListeners();
  }

  Future<void> loadCampersByOptionalActivityId(int optionalActivityId) async {
    _loading = true;
    notifyListeners();

    _campersOptionalActivity = await getCampersByOptionalActivityIdUseCase(
      optionalActivityId,
    );

    _loading = false;
    notifyListeners();
  }

  Future<void> loadCampersByActivityId(int activityScheduleId) async {
    _loading = true;
    notifyListeners();

    _campersActivity = await getCampersByActivityIdUseCase(activityScheduleId);

    _loading = false;
    notifyListeners();
  }

  Future<void> updateUploadAvatarCamper(int camperId, File imageFile) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      await updateUploadAvatarCamperUseCase(camperId, imageFile);

      if (_selectedCamper != null && _selectedCamper!.camperId == camperId) {
        await fetchCamperById(camperId);
      }
    } catch (e) {
      _error = "Lỗi khi cập nhật camper: $e";
      rethrow;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
