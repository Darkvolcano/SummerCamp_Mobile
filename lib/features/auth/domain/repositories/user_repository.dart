import '../entities/user.dart';

abstract class UserRepository {
  Future<User> login(String email, String password);
  Future<User> getUserProfile(String userId);
}
