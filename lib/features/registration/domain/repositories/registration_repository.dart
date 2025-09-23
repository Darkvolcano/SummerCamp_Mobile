import 'package:summercamp/features/registration/domain/entities/registration.dart';

abstract class RegistrationRepository {
  Future<List<Registration>> getRegistrations();
  Future<void> register(Registration registration);
  Future<void> cancelRegistration(int registrationId);
}
