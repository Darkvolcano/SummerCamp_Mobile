import 'package:summercamp/features/auth/domain/repositories/user_repository.dart';

class ResendOtp {
  final UserRepository repository;

  ResendOtp(this.repository);

  Future<void> call({required String email}) {
    return repository.resendOtp(email: email);
  }
}
