import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../models/user_model.dart';
import '../services/auth_api_service.dart';

class UserRepositoryImpl implements UserRepository {
  final AuthApiService service;
  UserRepositoryImpl(this.service);

  User _parseUser(Map<String, dynamic> data) {
    // API có thể trả user ở root hoặc trong field 'user'
    final raw = (data['user'] is Map<String, dynamic>) ? data['user'] : data;
    return UserModel.fromJson(Map<String, dynamic>.from(raw));
  }

  @override
  Future<User> login(String email, String password) async {
    final data = await service.login(email, password);
    return _parseUser(data);
  }

  @override
  Future<User> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    final data = await service.register(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
      password: password,
    );
    return _parseUser(data);
  }

  @override
  Future<User> getUserProfile(String userId) async {
    final data = await service.getUserProfile(userId);
    return _parseUser(data);
  }

  @override
  Future<void> logout() => service.logout();
}
