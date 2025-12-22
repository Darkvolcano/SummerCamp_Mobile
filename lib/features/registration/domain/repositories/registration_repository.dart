import 'package:summercamp/features/registration/domain/entities/optional_choice.dart';
import 'package:summercamp/features/registration/domain/entities/registration.dart';
import 'package:summercamp/features/registration/domain/entities/registration_camper_response.dart';

abstract class RegistrationRepository {
  Future<List<Registration>> getRegistrations();
  Future<void> register({
    required int campId,
    required List<int> camperIds,
    int? appliedPromotionId,
    String? note,
  });
  Future<String> registerPaymentLink({
    required int registrationId,
    List<OptionalChoice>? optionalChoices,
  });
  Future<void> cancelRegistration(int registrationId);
  Future<Registration> getRegistrationById(int registrationId);
  Future<void> registerOptionalActivity({
    required int camperId,
    required int activityId,
  });
  Future<List<RegistrationCamperResponse>> getRegistrationCamper();
  Future<void> refundRegistration({
    required int registrationId,
    required int bankUserId,
    required String reason,
  });
}
