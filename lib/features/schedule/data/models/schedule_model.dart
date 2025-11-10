import 'package:summercamp/core/enum/camp_status.enum.dart';
import 'package:summercamp/features/camp/domain/entities/camp_camp_type.dart';
import 'package:summercamp/features/schedule/domain/entities/schedule.dart';

class ScheduleModel extends Schedule {
  const ScheduleModel({
    required super.campId,
    required super.name,
    required super.description,
    required super.place,
    required super.startDate,
    required super.endDate,
    super.image,
    super.maxParticipants,
    super.minParticipants,
    required super.minAge,
    required super.maxAge,
    required super.price,
    required super.status,
    super.campType,
  });

  static CampStatus _statusFromString(String statusString) {
    switch (statusString) {
      case 'PendingApproval':
        return CampStatus.PendingApproval;
      case 'Rejected':
        return CampStatus.Rejected;
      case 'Published':
        return CampStatus.Published;
      case 'OpenForRegistration':
        return CampStatus.OpenForRegistration;
      case 'RegistrationClosed':
        return CampStatus.RegistrationClosed;
      case 'InProgress':
        return CampStatus.InProgress;
      case 'Completed':
        return CampStatus.Completed;
      case 'Canceled':
        return CampStatus.Canceled;
      default:
        print("Warning: Unknown CampStatus string '$statusString'");
        return CampStatus.PendingApproval;
    }
  }

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    String safeString(dynamic value) => value?.toString() ?? '';
    int safeInt(dynamic value) {
      if (value is int) return value;
      if (value is double) return value.round();
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    double safePrice(dynamic value) => (value is num) ? value.toDouble() : 0;

    final campTypeData = json['campType'];

    return ScheduleModel(
      campId: safeInt(json['campId']),
      name: safeString(json['name']),
      description: safeString(json['description']),
      place: safeString(json['place']),
      startDate: safeString(json['startDate']),
      endDate: safeString(json['endDate']),
      image: safeString(json['image']),
      minParticipants: safeInt(json['minParticipants']),
      maxParticipants: safeInt(json['maxParticipants']),
      minAge: safeInt(json['minAge']),
      maxAge: safeInt(json['maxAge']),
      price: safePrice(json['price']),
      status: _statusFromString(json['status']),
      campType: campTypeData != null
          ? CampCampType.fromJson(campTypeData)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'campId': campId,
    'name': name,
    'description': description,
    'place': place,
    'startDate': startDate,
    'endDate': endDate,
    'image': image,
    'maxParticipants': maxParticipants,
    'minParticipants': minParticipants,
    'minAge': minAge,
    'maxAge': maxAge,
    'price': price,
    'status': status,
    'campType': campType?.toJson(),
  };
}
