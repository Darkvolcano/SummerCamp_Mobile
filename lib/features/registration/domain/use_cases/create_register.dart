import 'package:summercamp/features/registration/domain/entities/registration.dart';
import 'package:summercamp/features/registration/domain/repositories/registration_repository.dart';

class CreateRegister {
  final RegistrationRepository repository;
  CreateRegister(this.repository);

  Future<void> call(Registration registration) {
    return repository.register(registration);
  }
}
