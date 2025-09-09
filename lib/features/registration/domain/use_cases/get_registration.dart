import '../entities/registration.dart';
import '../repositories/registration_repository.dart';

class GetRegistrations {
  final RegistrationRepository repository;
  GetRegistrations(this.repository);

  Future<List<Registration>> call() async {
    return await repository.getRegistrations();
  }
}
