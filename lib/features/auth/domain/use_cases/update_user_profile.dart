import 'package:summercamp/features/auth/domain/entities/user.dart';
import 'package:summercamp/features/auth/domain/repositories/user_repository.dart';

class UpdateUserProfile {
  final UserRepository repository;
  UpdateUserProfile(this.repository);

  Future<void> call(User user) async {
    await repository.updateUserProfile(user);
  }
}
