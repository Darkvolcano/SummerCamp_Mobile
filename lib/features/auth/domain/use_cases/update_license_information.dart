import 'package:summercamp/features/auth/domain/repositories/user_repository.dart';

class UpdateLicenseInformation {
  final UserRepository repository;

  UpdateLicenseInformation(this.repository);

  Future<void> call(int driverId, Map<String, dynamic> data) {
    return repository.updateLicenseInformation(driverId, data);
  }
}
