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
  Future<void> register(Registration registration) async {
    final model = RegistrationModel(
      registrationId: registration.registrationId,
      camperId: registration.camperId,
      campId: registration.campId,
      paymentId: registration.paymentId,
      registrationCreateAt: registration.registrationCreateAt,
      status: registration.status,
      price: registration.price,
      campName: registration.campName,
      campDescription: registration.campDescription,
      campPlace: registration.campPlace,
      campStartDate: registration.campStartDate,
      campEndDate: registration.campEndDate,
    );
    await service.registerCamper(model.toJson());
  }

  @override
  Future<void> cancelRegistration(int registrationId) async {
    await service.cancelRegistration(registrationId);
  }
}
