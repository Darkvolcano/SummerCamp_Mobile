import 'package:summercamp/features/registration/domain/repositories/registration_repository.dart';

class CreateRegister {
  final RegistrationRepository repository;
  CreateRegister(this.repository);

  Future<String> call({
    required int campId,
    required List<int> camperIds,
    String? appliedPromotionId,
  }) {
    return repository.register(
      campId: campId,
      camperIds: camperIds,
      appliedPromotionId: appliedPromotionId,
    );
  }
}
