import '../entities/registration.dart';
import '../repositories/registration_repository.dart';

class RegisterCamper {
  final RegistrationRepository repository;
  RegisterCamper(this.repository);

  Future<void> call(Registration registration) {
    return repository.registerCamper(registration);
  }
}
