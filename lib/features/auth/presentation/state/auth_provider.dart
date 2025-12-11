import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:summercamp/features/auth/domain/entities/bank_user.dart';
import 'package:summercamp/features/auth/domain/entities/user.dart';
import 'package:summercamp/features/auth/domain/repositories/user_repository.dart';
import 'package:summercamp/features/auth/domain/use_cases/change_password.dart';
import 'package:summercamp/features/auth/domain/use_cases/create_bank_user.dart';
import 'package:summercamp/features/auth/domain/use_cases/driver_register.dart';
import 'package:summercamp/features/auth/domain/use_cases/forgot_password.dart';
import 'package:summercamp/features/auth/domain/use_cases/get_bank_user.dart';
import 'package:summercamp/features/auth/domain/use_cases/get_user_profile.dart';
import 'package:summercamp/features/auth/domain/use_cases/get_users.dart';
import 'package:summercamp/features/auth/domain/use_cases/login_user.dart';
import 'package:summercamp/features/auth/domain/use_cases/register_response.dart';
import 'package:summercamp/features/auth/domain/use_cases/register_user.dart';
import 'package:summercamp/features/auth/domain/use_cases/resend_otp.dart';
import 'package:summercamp/features/auth/domain/use_cases/reset_password.dart';
import 'package:summercamp/features/auth/domain/use_cases/update_license_information.dart';
import 'package:summercamp/features/auth/domain/use_cases/update_upload_avatar.dart';
import 'package:summercamp/features/auth/domain/use_cases/update_upload_license.dart';
import 'package:summercamp/features/auth/domain/use_cases/update_user_profile.dart';
import 'package:summercamp/features/auth/domain/use_cases/upload_license.dart';
import 'package:summercamp/features/auth/domain/use_cases/verify_otp.dart';

class AuthProvider with ChangeNotifier {
  final LoginUser loginUserUseCase;
  final RegisterUser registerUserUseCase;
  final VerifyOtp verifyOTPUseCase;
  final GetUserProfile getUserProfileUseCase;
  final UpdateUserProfile updateUserProfileUseCase;
  final UpdateUploadAvatar updateUploadAvatarUseCase;
  final UserRepository repositoryUseCase;
  final GetUsers getUsersUseCase;
  final ResendOtp resendOTPUseCase;
  final ForgotPassword forgotPasswordUseCase;
  final ResetPassword resetPasswordUseCase;
  final DriverRegister driverRegisterUseCase;
  final UploadLicense uploadLicenseUseCase;
  final ChangePassword changePasswordUseCase;
  final GetBankUsers getBankUsersUseCase;
  final CreateBankUser createBankUserUseCase;
  final UpdateUploadLicense updateUploadLicenseUseCase;
  final UpdateLicenseInformation updateLicenseInformationUseCase;

  AuthProvider(
    this.loginUserUseCase,
    this.registerUserUseCase,
    this.verifyOTPUseCase,
    this.getUserProfileUseCase,
    this.updateUserProfileUseCase,
    this.updateUploadAvatarUseCase,
    this.repositoryUseCase,
    this.getUsersUseCase,
    this.resendOTPUseCase,
    this.forgotPasswordUseCase,
    this.resetPasswordUseCase,
    this.driverRegisterUseCase,
    this.uploadLicenseUseCase,
    this.changePasswordUseCase,
    this.getBankUsersUseCase,
    this.createBankUserUseCase,
    this.updateUploadLicenseUseCase,
    this.updateLicenseInformationUseCase,
  );

  List<User> _users = [];
  List<User> get users => _users;

  List<BankUser> _bankUsers = [];
  List<BankUser> get bankUsers => _bankUsers;

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

  Future<void> updateUploadAvatar(File imageFile) async {
    try {
      await updateUploadAvatarUseCase(imageFile);
    } catch (e) {
      print("Lỗi upload avatar: $e");
      rethrow;
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

  Future<String?> driverRegister({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String password,
    required String dob,
    required String licenseNumber,
    required String licenseExpiry,
    required String driverAddress,
  }) async {
    _setLoading(true);
    _error = null;
    notifyListeners();

    try {
      final result = await driverRegisterUseCase(
        firstName: firstName,
        lastName: lastName,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
        dob: dob,
        licenseNumber: licenseNumber,
        licenseExpiry: licenseExpiry,
        driverAddress: driverAddress,
      );

      final token = result['oneTimeUploadToken'] as String?;
      return token;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> uploadLicense(File imageFile, String token) async {
    try {
      await uploadLicenseUseCase(imageFile, token);
    } catch (e) {
      print("Lỗi upload bằng lái: $e");
      rethrow;
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    _setLoading(true);
    _error = null;
    notifyListeners();

    try {
      await changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmNewPassword: confirmNewPassword,
      );
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> loadBankUsers() async {
    _setLoading(true);
    notifyListeners();

    try {
      _bankUsers = await getBankUsersUseCase();
    } catch (e) {
      print("Lỗi load bank user: $e");
      _bankUsers = [];
    }

    _setLoading(false);
    notifyListeners();
  }

  Future<void> createBankUser({
    required String bankCode,
    required String bankName,
    required String bankNumber,
    required bool isPrimary,
  }) async {
    _setLoading(true);
    _error = null;
    notifyListeners();

    try {
      await createBankUserUseCase(
        bankCode: bankCode,
        bankName: bankName,
        bankNumber: bankNumber,
        isPrimary: isPrimary,
      );
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> updateUploadLicense(File imageFile) async {
    try {
      await updateUploadLicenseUseCase(imageFile);
    } catch (e) {
      print("Lỗi update upload bằng lái: $e");
      rethrow;
    }
  }

  Future<void> updateDriverLicense({
    required String licenseNumber,
    required String licenseExpiry,
    required String driverAddress,
    File? newLicenseImage,
  }) async {
    _setLoading(true);
    _error = null;
    notifyListeners();

    try {
      if (_currentUser == null) {
        throw Exception(
          "Không tìm thấy thông tin người dùng. Vui lòng đăng nhập lại.",
        );
      }

      final int? driverId = _currentUser!.userId;

      if (newLicenseImage != null) {
        await updateUploadLicenseUseCase(newLicenseImage);
      }

      final Map<String, dynamic> updateData = {
        'licenseNumber': licenseNumber,
        'licenseExpiry': licenseExpiry,
        'driverAddress': driverAddress,
      };

      await updateLicenseInformationUseCase(driverId!, updateData);

      await fetchProfileUser();
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }
}
