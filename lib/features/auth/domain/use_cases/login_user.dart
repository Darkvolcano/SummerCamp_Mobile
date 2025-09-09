import '../entities/user.dart';
import '../repositories/user_repository.dart';

class LoginUser {
  final UserRepository repository;

  LoginUser(this.repository);

  Future<User> call(String email, String password) {
    return repository.login(email, password);
  }
}
