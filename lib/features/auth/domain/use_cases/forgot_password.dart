import 'package:summercamp/features/auth/domain/entities/user.dart';
import 'package:summercamp/features/auth/domain/repositories/user_repository.dart';

class ForgotPassword {
  final UserRepository repository;

  ForgotPassword(this.repository);

  Future<User> call(String email) {
    return repository.forgotPassword(email);
  }
}
