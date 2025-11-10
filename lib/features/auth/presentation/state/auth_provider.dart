import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:summercamp/features/auth/domain/entities/user.dart';
import 'package:summercamp/features/auth/domain/repositories/user_repository.dart';
import 'package:summercamp/features/auth/domain/use_cases/forgot_password.dart';
import 'package:summercamp/features/auth/domain/use_cases/get_user_profile.dart';
import 'package:summercamp/features/auth/domain/use_cases/get_users.dart';
import 'package:summercamp/features/auth/domain/use_cases/login_user.dart';
import 'package:summercamp/features/auth/domain/use_cases/register_response.dart';
import 'package:summercamp/features/auth/domain/use_cases/register_user.dart';
import 'package:summercamp/features/auth/domain/use_cases/resend_otp.dart';
import 'package:summercamp/features/auth/domain/use_cases/reset_password.dart';
import 'package:summercamp/features/auth/domain/use_cases/update_user_profile.dart';
import 'package:summercamp/features/auth/domain/use_cases/verify_otp.dart';

class AuthProvider with ChangeNotifier {
  final LoginUser loginUserUseCase;
  final RegisterUser registerUserUseCase;
  final VerifyOtp verifyOTPUseCase;
  final GetUserProfile getUserProfileUseCase;
  final UpdateUserProfile updateUserProfileUseCase;
  final UserRepository repositoryUseCase;
  final GetUsers getUsersUseCase;
  final ResendOtp resendOTPUseCase;
  final ForgotPassword forgotPasswordUseCase;
  final ResetPassword resetPasswordUseCase;

  AuthProvider(
    this.loginUserUseCase,
    this.registerUserUseCase,
    this.verifyOTPUseCase,
    this.getUserProfileUseCase,
    this.updateUserProfileUseCase,
    this.repositoryUseCase,
    this.getUsersUseCase,
    this.resendOTPUseCase,
    this.forgotPasswordUseCase,
    this.resetPasswordUseCase,
  );

  List<User> _users = [];
  List<User> get users => _users;

  User? _selectedUser;
  User? get selectedUser => _selectedUser;

  User? _currentUser;
  String? _token;
  String? _userRole;
  bool _isLoading = false;
  String? _error;
  RegisterResponse? _registerResponse;

  User? get user => _currentUser;
  String? get token => _token;
  String? get userRole => _userRole;
  bool get isLoading => _isLoading;
  String? get error => _error;
  RegisterResponse? get registerResponse => _registerResponse;

  Future<void> login(String email, String password) async {
    _setLoading(true);
    _error = null;

    try {
      _currentUser = await loginUserUseCase(email, password);
      _token = await repositoryUseCase.getToken();

      _userRole = _currentUser?.role;
    } catch (e) {
      if (e is DioException && e.response?.data is Map<String, dynamic>) {
        _error = e.response!.data['message'] ?? "Lỗi không xác định";
      } else {
        _error = e.toString();
      }
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
      _registerResponse = await registerUserUseCase(
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
      _currentUser = await verifyOTPUseCase(email: email, otp: otp);
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
      _currentUser = await getUserProfileUseCase();
      _error = null;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateUserProfile(User user) async {
    _setLoading(true);
    _error = null;
    notifyListeners();

    try {
      await updateUserProfileUseCase(user);

      _currentUser = user;
      notifyListeners();
    } catch (e) {
      _error = "Lỗi khi cập nhật profile: $e";
      rethrow;
    } finally {
      _setLoading(false);
      notifyListeners();
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
    await repositoryUseCase.logout();
    _currentUser = null;
    _token = null;
    notifyListeners();
  }

  Future<void> resendOtp({required String email}) async {
    try {
      await resendOTPUseCase(email: email);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<String> forgotPasswords(String email) async {
    _setLoading(true);
    try {
      final message = await forgotPasswordUseCase(email);
      _error = null;
      return message;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<String> resetPasswords(
    String email,
    String otp,
    String newPassword,
  ) async {
    _setLoading(true);
    try {
      final message = await resetPasswordUseCase(email, otp, newPassword);
      _error = null;
      return message;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }
}
