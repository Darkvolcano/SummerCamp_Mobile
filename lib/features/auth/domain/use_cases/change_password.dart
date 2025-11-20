import 'package:summercamp/features/auth/domain/repositories/user_repository.dart';

class ChangePassword {
  final UserRepository repository;
  ChangePassword(this.repository);

  Future<void> call({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    await repository.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmNewPassword: confirmNewPassword,
    );
  }
}
