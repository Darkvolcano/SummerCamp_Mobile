import 'package:summercamp/features/auth/domain/entities/user.dart';

abstract class UserRepository {
  Future<User> login(String email, String password);
  Future<User> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String password,
  });
  Future<User> getUserProfile(String userId);
  Future<User> getUserProfiles();
  Future<void> logout();
  Future<List<User>> getUsers();
  Future<String?> getToken();
}
