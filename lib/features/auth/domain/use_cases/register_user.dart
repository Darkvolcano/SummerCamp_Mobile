import 'package:summercamp/features/auth/domain/repositories/user_repository.dart';
import 'package:summercamp/features/auth/domain/use_cases/register_response.dart';

class RegisterUser {
  final UserRepository repository;
  RegisterUser(this.repository);

  Future<RegisterResponse> call({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String password,
    required String dob,
  }) {
    return repository.register(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
      password: password,
      dob: dob,
    );
  }
}
