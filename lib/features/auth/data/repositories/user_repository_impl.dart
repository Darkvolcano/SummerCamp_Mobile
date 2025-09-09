import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../models/user_model.dart';
import '../services/auth_api_service.dart';

class UserRepositoryImpl implements UserRepository {
  final AuthApiService apiService;

  UserRepositoryImpl(this.apiService);

  @override
  Future<User> login(String email, String password) async {
    final data = await apiService.login(email, password);
    return UserModel.fromJson(data);
  }

  @override
  Future<User> getUserProfile(String userId) async {
    final data = await apiService.getUserProfile(userId);
    return UserModel.fromJson(data);
  }
}
