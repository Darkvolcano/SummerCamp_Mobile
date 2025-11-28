import 'package:summercamp/features/registration/domain/entities/registration_camper.dart';
import 'package:summercamp/features/schedule/domain/entities/camper_transport.dart';
import 'package:summercamp/features/schedule/domain/entities/location.dart';

class CamperTransportModel extends CamperTransport {
  const CamperTransportModel({
    required super.camperTransportId,
    required super.transportScheduleId,
    required super.camper,
    required super.location,
    required super.isAbsent,
    super.checkInTime,
    super.checkoutTime,
    required super.status,
    super.note,
  });

  factory CamperTransportModel.fromJson(Map<String, dynamic> json) {
    final camperData = json['camper'];
    final locationData = json['location'];

    return CamperTransportModel(
      camperTransportId: json['camperTransportId'] ?? 0,
      transportScheduleId: json['transportScheduleId'],
      camper: RegistrationCamper.fromJson(camperData),
      location: Location.fromJson(locationData),
      isAbsent: json['isAbsent'],
      checkInTime: json['checkInTime'],
      checkoutTime: json['checkoutTime'],
      status: json['status'],
      note: json['note'],
    );
  }

  Map<String, dynamic> toJson() => {
    'camperTransportId': camperTransportId,
    'transportScheduleId': transportScheduleId,
    'camper': camper.toJson(),
    'location': location.toJson(),
    'isAbsent': isAbsent,
    'checkInTime': checkInTime,
    'checkoutTime': checkoutTime,
    'status': status,
    'note': note,
  };
}
