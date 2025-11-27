import 'dart:io';
import 'package:summercamp/features/auth/domain/repositories/user_repository.dart';

class UpdateUploadAvatar {
  final UserRepository repository;
  UpdateUploadAvatar(this.repository);

  Future<void> call(File imageFile) {
    return repository.updateUploadAvatar(imageFile);
  }
}
