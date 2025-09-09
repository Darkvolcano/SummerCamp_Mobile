import '../repositories/registration_repository.dart';

class CancelRegistration {
  final RegistrationRepository repository;
  CancelRegistration(this.repository);

  Future<void> call(String id) {
    return repository.cancelRegistration(id);
  }
}
