import 'dart:io';
import 'package:summercamp/features/auth/domain/repositories/user_repository.dart';

class UpdateUploadLicense {
  final UserRepository repository;
  UpdateUploadLicense(this.repository);

  Future<void> call(File imageFile) {
    return repository.updateUploadLicense(imageFile);
  }
}
