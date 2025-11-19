import 'package:summercamp/features/auth/domain/repositories/user_repository.dart';

class DriverRegister {
  final UserRepository repository;
  DriverRegister(this.repository);

  Future<void> call({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String password,
    required String dob,
    required String licenseNumber,
    required String licenseExpiry,
    required String driverAddress,
  }) async {
    await repository.driverRegister(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
      password: password,
      dob: dob,
      licenseNumber: licenseNumber,
      licenseExpiry: licenseExpiry,
      driverAddress: driverAddress,
    );
  }
}
