import 'package:summercamp/features/registration/domain/entities/registration.dart';

class RegistrationModel extends Registration {
  const RegistrationModel({
    required super.id,
    required super.camperId,
    required super.campId,
    required super.paymentId,
    required super.registrationCreateAt,
    required super.status,
    required super.price,
    required super.campName,
    required super.campDescription,
    required super.campPlace,
    required super.campStartDate,
    required super.campEndDate,
    super.promotionId,
    super.promotionCode,
    super.discount,
  });

  factory RegistrationModel.fromJson(Map<String, dynamic> json) {
    return RegistrationModel(
      id: json['registrationId'],
      camperId: json['camperId'],
      campId: json['campId'],
      paymentId: json['paymentId'],
      registrationCreateAt: DateTime.parse(json['registrationCreateAt']),
      status: json['status'],
      price: json['price'],
      campName: json['campName'],
      campDescription: json['campDescription'],
      campPlace: json['campPlace'],
      campStartDate: DateTime.parse(json['campStartDate']),
      campEndDate: DateTime.parse(json['campEndDate']),
      promotionId: json['promotionId'],
      promotionCode: json['promotionCode'],
      discount: json['discount'],
    );
  }

  Map<String, dynamic> toJson() => {
    'registrationId': id,
    'camperId': camperId,
    'campId': campId,
    'paymentId': paymentId,
    'registrationCreateAt': registrationCreateAt.toIso8601String(),
    'status': status,
    'price': price,
    'campName': campName,
    'campDescription': campDescription,
    'campPlace': campPlace,
    'campStartDate': campStartDate.toIso8601String(),
    'campEndDate': campEndDate.toIso8601String(),
    'promotionId': promotionId,
    'promotionCode': promotionCode,
    'discount': discount,
  };
}
