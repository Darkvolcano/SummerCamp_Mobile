import 'package:summercamp/features/registration/domain/repositories/registration_repository.dart';

class CreateRegisterOptionalCamperActivity {
  final RegistrationRepository repository;
  CreateRegisterOptionalCamperActivity(this.repository);

  Future<void> call({required int camperId, required int activityId}) async {
    await repository.registerOptionalActivity(
      camperId: camperId,
      activityId: activityId,
    );
  }
}
