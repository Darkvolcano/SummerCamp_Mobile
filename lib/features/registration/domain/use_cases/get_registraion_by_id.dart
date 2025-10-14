import 'package:summercamp/features/registration/domain/entities/registration.dart';
import 'package:summercamp/features/registration/domain/repositories/registration_repository.dart';

class GetRegistrationById {
  final RegistrationRepository repository;

  GetRegistrationById(this.repository);

  Future<Registration> call(int registrationid) {
    return repository.getRegistrationById(registrationid);
  }
}
