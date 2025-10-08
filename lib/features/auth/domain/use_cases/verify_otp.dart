import 'package:summercamp/features/auth/domain/entities/user.dart';
import 'package:summercamp/features/auth/domain/repositories/user_repository.dart';

class VerifyOtp {
  final UserRepository repository;
  VerifyOtp(this.repository);

  Future<User> call({required String email, required String otp}) {
    return repository.verifyOTP(email: email, otp: otp);
  }
}
