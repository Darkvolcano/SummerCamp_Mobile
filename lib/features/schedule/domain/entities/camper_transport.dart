import 'package:summercamp/features/registration/domain/entities/registration_camper.dart';
import 'package:summercamp/features/schedule/domain/entities/location.dart';

class CamperTransport {
  final int camperTransportId;
  final int transportScheduleId;
  final RegistrationCamper camper;
  final Location location;
  final bool isAbsent;
  final String? checkInTime;
  final String? checkoutTime;
  final String status;
  final String? note;

  const CamperTransport({
    required this.camperTransportId,
    required this.transportScheduleId,
    required this.camper,
    required this.location,
    required this.isAbsent,
    this.checkInTime,
    this.checkoutTime,
    required this.status,
    this.note,
  });
}
