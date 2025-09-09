import '../entities/registration.dart';

abstract class RegistrationRepository {
  Future<List<Registration>> getRegistrations();
  Future<void> registerCamper(Registration registration);
  Future<void> cancelRegistration(String id);
}
