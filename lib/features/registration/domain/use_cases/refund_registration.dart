import 'package:summercamp/features/registration/domain/repositories/registration_repository.dart';

class RefundRegistration {
  final RegistrationRepository repository;
  RefundRegistration(this.repository);

  Future<void> call({
    required int registrationId,
    required int bankUserId,
    required String reason,
  }) async {
    await repository.refundRegistration(
      registrationId: registrationId,
      bankUserId: bankUserId,
      reason: reason,
    );
  }
}
