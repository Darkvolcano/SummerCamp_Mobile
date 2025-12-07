import 'package:summercamp/features/registration/domain/entities/registration_camper_response.dart';
import 'package:summercamp/features/registration/domain/repositories/registration_repository.dart';

class GetRegistrationCamper {
  final RegistrationRepository repository;

  GetRegistrationCamper(this.repository);

  Future<List<RegistrationCamperResponse>> call() {
    return repository.getRegistrationCamper();
  }
}
