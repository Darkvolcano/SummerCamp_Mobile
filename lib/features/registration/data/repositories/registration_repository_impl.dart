import 'package:summercamp/features/registration/data/models/activity_schedule_model.dart';
import 'package:summercamp/features/registration/data/models/registration_model.dart';
import 'package:summercamp/features/registration/data/services/registration_api_service.dart';
import 'package:summercamp/features/registration/domain/entities/activity_schedule.dart';
import 'package:summercamp/features/registration/domain/entities/optional_choice.dart';
import 'package:summercamp/features/registration/domain/entities/registration.dart';
import 'package:summercamp/features/registration/domain/repositories/registration_repository.dart';

class RegistrationRepositoryImpl implements RegistrationRepository {
  final RegistrationApiService service;

  RegistrationRepositoryImpl(this.service);

  @override
  Future<List<Registration>> getRegistrations() async {
    final list = await service.fetchRegistrations();
    return list.map((e) => RegistrationModel.fromJson(e)).toList();
  }

  @override
  Future<void> register({
    required int campId,
    required List<int> camperIds,
    String? appliedPromotionId,
    String? note,
  }) async {
    await service.registerCamp(
      camperIds: camperIds,
      campId: campId,
      appliedPromotionId: appliedPromotionId,
      note: note,
    );
  }

  @override
  Future<String> registerPaymentLink({
    required int registrationId,
    List<OptionalChoice>? optionalChoices,
  }) async {
    final List<Map<String, dynamic>> choicesJson =
        optionalChoices?.map((choice) => choice.toJson()).toList() ?? [];

    final Map<String, dynamic> requestBody = {'optionalChoices': choicesJson};

    return await service.createRegisterPaymentLink(registrationId, requestBody);
  }

  @override
  Future<void> cancelRegistration(int registrationId) async {
    await service.cancelRegistration(registrationId);
  }

  @override
  Future<Registration> getRegistrationById(int registrationId) async {
    final data = await service.fetchRegistrationById(registrationId);
    return RegistrationModel.fromJson(data);
  }

  @override
  Future<void> registerOptionalActivity({
    required int camperId,
    required int activityId,
  }) async {
    await service.registerOptionalCamperActivity(
      camperId: camperId,
      activityId: activityId,
    );
  }

  @override
  Future<List<ActivitySchedule>> getActivitySchedulesOptionalByCampId(
    int campId,
  ) async {
    final list = await service.fetchActivitySchedulesOptionalByCampId(campId);
    return list.map((e) => ActivityScheduleModel.fromJson(e)).toList();
  }

  @override
  Future<List<ActivitySchedule>> getActivitySchedulesCoreByCampId(
    int campId,
  ) async {
    final list = await service.fetchActivitySchedulesCoreByCampId(campId);
    return list.map((e) => ActivityScheduleModel.fromJson(e)).toList();
  }
}
