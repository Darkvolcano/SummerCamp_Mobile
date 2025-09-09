import '../../domain/entities/registration.dart';
import '../../domain/repositories/registration_repository.dart';
import '../models/registration_model.dart';
import '../services/registration_api_service.dart';

class RegistrationRepositoryImpl implements RegistrationRepository {
  final RegistrationApiService service;

  RegistrationRepositoryImpl(this.service);

  @override
  Future<List<Registration>> getRegistrations() async {
    final list = await service.fetchRegistrations();
    return list.map((e) => RegistrationModel.fromJson(e)).toList();
  }

  @override
  Future<void> registerCamper(Registration registration) async {
    // convert entity -> model -> json
    final model = RegistrationModel(
      id: registration.id,
      camperId: registration.camperId,
      campId: registration.campId,
      date: registration.date,
    );
    await service.registerCamper(model.toJson());
  }

  @override
  Future<void> cancelRegistration(String id) async {
    await service.cancelRegistration(id);
  }
}
