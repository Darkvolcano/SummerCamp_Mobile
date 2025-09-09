import 'package:summercamp/features/auth/domain/entities/user.dart';
import 'package:summercamp/features/auth/domain/repositories/user_repository.dart';

class GetUserProfiles {
  final UserRepository repository;
  GetUserProfiles(this.repository);

  Future<User> call() {
    return repository.getUserProfiles();
  }
}
