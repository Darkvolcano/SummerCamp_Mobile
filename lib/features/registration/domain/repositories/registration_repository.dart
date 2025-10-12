import 'package:summercamp/features/registration/domain/entities/registration.dart';

abstract class RegistrationRepository {
  Future<List<Registration>> getRegistrations();
  Future<String> register({
    required int campId,
    required List<int> camperIds,
    String? appliedPromotionId,
  });
  Future<void> cancelRegistration(int registrationId);
}
