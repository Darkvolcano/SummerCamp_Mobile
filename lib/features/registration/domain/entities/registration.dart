import 'package:summercamp/core/enum/status.dart';
import 'package:summercamp/features/registration/domain/entities/registration_camper.dart';

class Registration {
  final int registrationId;
  final int? camperId;
  final int? campId;
  final int paymentId;
  final DateTime registrationCreateAt;
  final Status status;
  final int? price;
  final String? campName;
  final String? campDescription;
  final String? campPlace;
  final String? campStartDate;
  final String? campEndDate;
  final int? appliedPromotionId;
  final String? promotionCode;
  final int? discount;
  final List<RegistrationCamper> campers;

  const Registration({
    required this.registrationId,
    this.camperId,
    this.campId,
    required this.paymentId,
    required this.registrationCreateAt,
    required this.status,
    this.price,
    this.campName,
    this.campDescription,
    this.campPlace,
    this.campStartDate,
    this.campEndDate,
    this.appliedPromotionId,
    this.promotionCode,
    this.discount,
    required this.campers,
  });
}
