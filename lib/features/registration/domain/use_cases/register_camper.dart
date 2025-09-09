import 'package:summercamp/features/registration/domain/entities/registration.dart';
import 'package:summercamp/features/registration/domain/repositories/registration_repository.dart';

class RegisterCamper {
  final RegistrationRepository repository;
  RegisterCamper(this.repository);

  Future<void> call(Registration registration) {
    return repository.registerCamper(registration);
  }
}
