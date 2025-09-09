import 'package:summercamp/features/registration/domain/repositories/registration_repository.dart';

class CancelRegistration {
  final RegistrationRepository repository;
  CancelRegistration(this.repository);

  Future<void> call(String id) {
    return repository.cancelRegistration(id);
  }
}
