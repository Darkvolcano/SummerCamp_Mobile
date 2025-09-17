import 'package:shared_preferences/shared_preferences.dart';
import 'package:summercamp/features/auth/data/models/user_model.dart';
import 'package:summercamp/features/auth/data/services/auth_api_service.dart';
import 'package:summercamp/features/auth/domain/entities/user.dart';
import 'package:summercamp/features/auth/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final AuthApiService service;
  UserRepositoryImpl(this.service);

  User _parseUser(Map<String, dynamic> data) {
    final raw = (data['user'] is Map<String, dynamic>) ? data['user'] : data;
    return UserModel.fromJson(Map<String, dynamic>.from(raw));
  }

  @override
  Future<User> login(String email, String password) async {
    final data = await service.login(email, password);

    if (data['token'] != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", data['token']);
    }

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

    if (data['token'] != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", data['token']);
    }

    return _parseUser(data);
  }

  @override
  Future<User> getUserProfile(String userId) async {
    final data = await service.getUserProfile(userId);
    return _parseUser(data);
  }

  @override
  Future<User> getUserProfiles() async {
    final data = await service.getUserProfiles();
    return _parseUser(data);
  }

  @override
  Future<List<User>> getUsers() async {
    final list = await service.fetchUsers();
    return list.map((e) => UserModel.fromJson(e)).toList();
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
  }

  @override
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }
}
