import 'dart:io';
import 'package:summercamp/features/auth/domain/repositories/user_repository.dart';

class UploadLicense {
  final UserRepository repository;
  UploadLicense(this.repository);

  Future<void> call(File imageFile, String token) {
    return repository.uploadLicense(imageFile, token);
  }
}
