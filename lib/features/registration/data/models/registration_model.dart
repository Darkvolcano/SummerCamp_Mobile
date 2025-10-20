import 'package:summercamp/core/enum/camp_status.enum.dart';
import 'package:summercamp/features/registration/domain/entities/registration.dart';
import 'package:summercamp/features/registration/domain/entities/registration_camper.dart';

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
  });

  static CampStatus _statusFromString(String statusStr) {
    switch (statusStr) {
      case 'Active':
      case 'Approved':
      case 'Inprogress':
        return CampStatus.InProgress;
      case 'Pending':
      case 'PendingPayment':
      case 'PendingApproval':
        return CampStatus.PendingApproval;
      case 'Completed':
        return CampStatus.Completed;
      case 'Canceled':
      case 'Rejected':
        return CampStatus.Canceled;
      case 'OpenForRegistration':
        return CampStatus.OpenForRegistration;
      // Thêm các trường hợp khác nếu cần
      default:
        // Mặc định là một trạng thái an toàn
        return CampStatus.PendingApproval;
    }
  }

  factory RegistrationModel.fromJson(Map<String, dynamic> json) {
    var camperList = <RegistrationCamper>[];
    if (json['campers'] != null && json['campers'] is List) {
      camperList = (json['campers'] as List)
          .map((camperJson) => RegistrationCamper.fromJson(camperJson))
          .toList();
    }

    return RegistrationModel(
      registrationId: json['registrationId'],
      camperId: json['camperId'],
      campId: json['campId'],
      paymentId: json['paymentId'],
      registrationCreateAt: DateTime.parse(json['registrationCreateAt']),
      status: _statusFromString(json['status']),
      price: json['price'],
      campName: json['campName'],
      campDescription: json['campDescription'],
      campPlace: json['campPlace'],
      campStartDate: json['campStartDate'],
      campEndDate: json['campEndDate'],
      appliedPromotionId: json['appliedPromotionId'],
      promotionCode: json['promotionCode'],
      discount: json['discount'],
      campers: camperList,
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
