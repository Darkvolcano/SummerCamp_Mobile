import 'package:summercamp/core/enum/camp_status.enum.dart';
import 'package:summercamp/features/camp/domain/entities/camp.dart';
import 'package:summercamp/features/camp/domain/entities/camp_camp_type.dart';
import 'package:summercamp/features/camp/domain/entities/camp_promtion.dart';

class CampModel extends Camp {
  const CampModel({
    required super.campId,
    required super.name,
    required super.description,
    required super.place,
    required super.startDate,
    required super.endDate,
    super.image,
    super.maxParticipants,
    super.minParticipants,
    required super.price,
    required super.status,
    required super.registrationStartDate,
    required super.registrationEndDate,
    super.campType,
    super.promotion,
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

  factory CampModel.fromJson(Map<String, dynamic> json) {
    String safeString(dynamic value) => value?.toString() ?? '';
    int safeInt(dynamic value) {
      if (value is int) return value;
      if (value is double) return value.round();
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    int safePrice(dynamic value) => (value is num) ? value.toInt() : 0;

    DateTime safeDateTime(dynamic value) {
      if (value is String) {
        try {
          return DateTime.parse(value);
        } catch (e) {
          return DateTime.fromMillisecondsSinceEpoch(0);
        }
      }
      return DateTime.fromMillisecondsSinceEpoch(0);
    }

    final campTypeData = json['campType'];
    final promotionData = json['promotion'];

    return CampModel(
      campId: safeInt(json['campId']),
      name: safeString(json['name']),
      description: safeString(json['description']),
      place: safeString(json['place']),
      startDate: safeString(json['startDate']),
      endDate: safeString(json['endDate']),
      image: safeString(json['image']),
      minParticipants: safeInt(json['minParticipants']),
      maxParticipants: safeInt(json['maxParticipants']),
      price: safePrice(json['price']),
      status: _statusFromString(json['status']),
      registrationStartDate: safeDateTime(json['registrationStartDate']),
      registrationEndDate: safeDateTime(json['registrationEndDate']),
      campType: campTypeData != null
          ? CampCampType.fromJson(campTypeData)
          : null,
      promotion: promotionData != null
          ? CampPromotion.fromJson(promotionData)
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
    'price': price,
    'status': status,
    'registrationStartDate': registrationStartDate.toIso8601String(),
    'registrationEndDate': registrationEndDate.toIso8601String(),
    'campType': campType?.toJson(),
    'promotion': promotion?.toJson(),
  };
}
