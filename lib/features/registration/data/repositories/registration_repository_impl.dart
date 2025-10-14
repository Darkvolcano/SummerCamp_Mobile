import 'package:summercamp/features/registration/data/models/registration_model.dart';
import 'package:summercamp/features/registration/data/services/registration_api_service.dart';
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
  Future<String> register({
    required int campId,
    required List<int> camperIds,
    String? appliedPromotionId,
  }) async {
    return await service.registerCamp(
      camperIds: camperIds,
      campId: campId,
      appliedPromotionId: appliedPromotionId,
    );
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
}
