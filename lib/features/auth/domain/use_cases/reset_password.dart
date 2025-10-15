import 'package:summercamp/features/auth/domain/repositories/user_repository.dart';

class ResetPassword {
  final UserRepository repository;

  ResetPassword(this.repository);

  Future<String> call(String email, String otp, String newPassword) {
    return repository.resetPassword(email, otp, newPassword);
  }
}
