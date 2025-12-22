import 'package:summercamp/core/enum/registration_status.enum.dart';
import 'package:summercamp/features/registration/domain/entities/registration.dart';
import 'package:summercamp/features/registration/domain/entities/registration_camper.dart';
import 'package:summercamp/features/registration/domain/entities/registration_optional_choice.dart';

class RegistrationModel extends Registration {
  const RegistrationModel({
    required super.registrationId,
    super.camperId,
    super.campId,
    super.paymentId,
    required super.registrationCreateAt,
    required super.status,
    super.price,
    required super.campName,
    super.campDescription,
    super.campPlace,
    super.campStartDate,
    super.campEndDate,
    super.appliedPromotionId,
    super.promotionCode,
    super.discount,
    required super.campers,
    super.optionalChoices,
  });

  static RegistrationStatus _statusFromString(String status) {
    switch (status) {
      case 'PendingApproval':
        return RegistrationStatus.PendingApproval;
      case 'Approved':
        return RegistrationStatus.Approved;
      case 'PendingPayment':
        return RegistrationStatus.PendingPayment;
      case 'Confirmed':
        return RegistrationStatus.Confirmed;
      case 'Completed':
        return RegistrationStatus.Completed;
      case 'Canceled':
        return RegistrationStatus.Canceled;
      case 'PendingRefund':
        return RegistrationStatus.PendingRefund;
      case 'Refunded':
        return RegistrationStatus.Refunded;
      // case 'PendingCompletion':
      //   return RegistrationStatus.PendingCompletion;
      // case 'PendingAssignGroup':
      //   return RegistrationStatus.PendingAssignGroup;
      default:
        throw Exception('Unknown registration status: $status');
    }
  }

  factory RegistrationModel.fromJson(Map<String, dynamic> json) {
    final campData = json['camp'];
    String campName = '';
    String campStartDate = '';

    if (campData != null && campData is Map<String, dynamic>) {
      campName = campData['name']?.toString() ?? '';
      campStartDate = campData['startDate']?.toString() ?? '';
    } else {
      campName = json['campName']?.toString() ?? '';
    }

    var camperList = <RegistrationCamper>[];
    if (json['campers'] != null && json['campers'] is List) {
      camperList = (json['campers'] as List)
          .map((camperJson) => RegistrationCamper.fromJson(camperJson))
          .toList();
    }

    var optionalChoices = <RegistrationOptionalChoice>[];
    if (json['optionalChoices'] != null && json['optionalChoices'] is List) {
      optionalChoices = (json['optionalChoices'] as List)
          .map((e) => RegistrationOptionalChoice.fromJson(e))
          .toList();
    }

    return RegistrationModel(
      registrationId: json['registrationId'] as int,

      registrationCreateAt: DateTime.parse(json['registrationCreateAt']),
      status: _statusFromString(json['status']),

      price:
          (json['finalPrice'] as num?)?.toInt() ??
          (json['price'] as num?)?.toInt(),

      campName: campName,

      campDescription: json['campDescription']?.toString(),
      campPlace: json['campPlace']?.toString(),

      campStartDate: campStartDate.isNotEmpty
          ? campStartDate
          : json['campStartDate']?.toString(),
      campEndDate: json['campEndDate']?.toString(),

      appliedPromotionId: json['appliedPromotionId'],
      promotionCode: json['promotionCode'],
      discount: (json['discount'] as num?)?.toInt(),

      campers: camperList,
      optionalChoices: optionalChoices,
    );
  }

  Map<String, dynamic> toJson() => {
    'registrationId': registrationId,
    'camperId': camperId,
    'campId': campId,
    'paymentId': paymentId,
    'registrationCreateAt': registrationCreateAt.toIso8601String(),
    'status': status,
    'price': price,
    'campName': campName,
    'campDescription': campDescription,
    'campPlace': campPlace,
    'campStartDate': campStartDate,
    'campEndDate': campEndDate,
    'appliedPromotionId': appliedPromotionId,
    'promotionCode': promotionCode,
    'discount': discount,
  };
}
