import 'package:summercamp/features/auth/domain/repositories/user_repository.dart';

class ForgotPassword {
  final UserRepository repository;

  ForgotPassword(this.repository);

  Future<String> call(String email) {
    return repository.forgotPassword(email);
  }
}
