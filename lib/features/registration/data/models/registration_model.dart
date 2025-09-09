import '../../domain/entities/registration.dart';

class RegistrationModel extends Registration {
  const RegistrationModel({
    required super.id,
    required super.camperId,
    required super.campId,
    required super.date,
  });

  factory RegistrationModel.fromJson(Map<String, dynamic> json) {
    return RegistrationModel(
      id: json['registrationId'],
      camperId: json['camperId'],
      campId: json['campId'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() => {
    'registrationId': id,
    'camperId': camperId,
    'campId': campId,
    'date': date.toIso8601String(),
  };
}
