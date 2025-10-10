import 'package:summercamp/features/registration/domain/entities/registration.dart';

class RegistrationModel extends Registration {
  const RegistrationModel({
    required super.registrationId,
    required super.camperId,
    required super.campId,
    required super.paymentId,
    required super.registrationCreateAt,
    required super.status,
    required super.price,
    super.campName,
    super.campDescription,
    super.campPlace,
    super.campStartDate,
    super.campEndDate,
    required super.appliedPromotionId,
    super.promotionCode,
    super.discount,
  });

  factory RegistrationModel.fromJson(Map<String, dynamic> json) {
    return RegistrationModel(
      registrationId: json['registrationId'],
      camperId: json['camperId'],
      campId: json['campId'],
      paymentId: json['paymentId'],
      registrationCreateAt: DateTime.parse(json['registrationCreateAt']),
      status: json['status'],
      price: json['price'],
      campName: json['campName'],
      campDescription: json['campDescription'],
      campPlace: json['campPlace'],
      campStartDate: json['campStartDate'],
      campEndDate: json['campEndDate'],
      appliedPromotionId: json['appliedPromotionId'],
      promotionCode: json['promotionCode'],
      discount: json['discount'],
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
