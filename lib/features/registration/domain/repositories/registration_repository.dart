import 'package:summercamp/features/registration/domain/entities/registration.dart';

abstract class RegistrationRepository {
  Future<List<Registration>> getRegistrations();
  Future<void> register({
    required int campId,
    required List<int> camperIds,
    String? appliedPromotionId,
    String? note,
  });
  Future<void> cancelRegistration(int registrationId);
  Future<Registration> getRegistrationById(int registrationId);
}
