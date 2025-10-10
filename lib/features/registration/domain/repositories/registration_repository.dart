import 'package:summercamp/features/registration/domain/entities/registration.dart';

abstract class RegistrationRepository {
  Future<List<Registration>> getRegistrations();
  Future<String> register({
    required int campId,
    required List<int> camperIds,
    required int paymentId,
    String? appliedPromotionId,
    required DateTime registrationCreateAt,
  });
  Future<void> cancelRegistration(int registrationId);
}
