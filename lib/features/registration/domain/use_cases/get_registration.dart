import 'package:summercamp/features/registration/domain/entities/registration.dart';
import 'package:summercamp/features/registration/domain/repositories/registration_repository.dart';

class GetRegistrations {
  final RegistrationRepository repository;
  GetRegistrations(this.repository);

  Future<List<Registration>> call() async {
    return await repository.getRegistrations();
  }
}
