import 'package:summercamp/features/registration/domain/repositories/registration_repository.dart';

class CreateRegister {
  final RegistrationRepository repository;
  CreateRegister(this.repository);

  Future<String> call({
    required int campId,
    required List<int> camperIds,
    required int paymentId,
    String? appliedPromotionId,
    required DateTime registrationCreateAt,
  }) {
    return repository.register(
      campId: campId,
      camperIds: camperIds,
      paymentId: paymentId,
      appliedPromotionId: appliedPromotionId,
      registrationCreateAt: registrationCreateAt,
    );
  }
}
