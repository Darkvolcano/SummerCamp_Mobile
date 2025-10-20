import 'package:summercamp/features/registration/domain/repositories/registration_repository.dart';

class CreateRegisterPaymentLink {
  final RegistrationRepository repository;
  CreateRegisterPaymentLink(this.repository);

  Future<String> call(int registrationId) async {
    return await repository.registerPaymentLink(registrationId);
  }
}
