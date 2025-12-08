import 'dart:io';
import 'package:summercamp/features/camper/domain/repositories/camper_repository.dart';

class UpdateUploadAvatarCamper {
  final CamperRepository repository;
  UpdateUploadAvatarCamper(this.repository);

  Future<void> call(int camperId, File imageFile) async {
    await repository.updateUploadAvatarCamper(camperId, imageFile);
  }
}
