import 'package:flutter/foundation.dart';
import 'package:summercamp/features/auth/domain/entities/user.dart';
import 'package:summercamp/features/auth/domain/repositories/user_repository.dart';
import 'package:summercamp/features/auth/domain/use_cases/get_user_profile.dart';
import 'package:summercamp/features/auth/domain/use_cases/get_user_profiles.dart';
import 'package:summercamp/features/auth/domain/use_cases/get_users.dart';
import 'package:summercamp/features/auth/domain/use_cases/login_user.dart';
import 'package:summercamp/features/auth/domain/use_cases/register_response.dart';
import 'package:summercamp/features/auth/domain/use_cases/register_user.dart';
import 'package:summercamp/features/auth/domain/use_cases/verify_otp.dart';

class AuthProvider with ChangeNotifier {
  final LoginUser loginUser;
  final RegisterUser registerUser;
  final VerifyOtp verifyOTP;
  final GetUserProfile getUserProfile;
  final GetUserProfiles getUserProfiles;
  final UserRepository repository;
  final GetUsers getUsersUseCase;

  AuthProvider({
    required this.loginUser,
    required this.registerUser,
    required this.verifyOTP,
    required this.getUserProfile,
    required this.getUserProfiles,
    required this.repository,
    required this.getUsersUseCase,
  });

  List<User> _users = [];
  List<User> get users => _users;

  User? _currentUser;
  String? _token;
  bool _isLoading = false;
  String? _error;
  RegisterResponse? _registerResponse;

  User? get user => _currentUser;
  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get error => _error;
  RegisterResponse? get registerResponse => _registerResponse;

  Future<void> login(String email, String password) async {
    _setLoading(true);
    try {
      _currentUser = await loginUser(email, password);
      _token = await repository.getToken();

      _error = null;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String password,
    required String dob,
  }) async {
    _setLoading(true);
    try {
      _registerResponse = await registerUser(
        firstName: firstName,
        lastName: lastName,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
        dob: dob,
      );
      _error = null;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> verifyOtp({required String email, required String otp}) async {
    _setLoading(true);
    try {
      _currentUser = await verifyOTP(email: email, otp: otp);
      _error = null;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchProfileById(String userId) async {
    _setLoading(true);
    try {
      _currentUser = await getUserProfile(userId);
      _error = null;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchProfileUser() async {
    _setLoading(true);
    try {
      _currentUser = await getUserProfiles();
      _error = null;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadUsers() async {
    _isLoading = true;
    notifyListeners();

    _users = await getUsersUseCase();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    await repository.logout();
    _currentUser = null;
    _token = null;
    notifyListeners();
  }

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }
}
