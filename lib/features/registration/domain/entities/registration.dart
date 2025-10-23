import 'package:summercamp/core/enum/registration_status.enum.dart';
import 'package:summercamp/features/registration/domain/entities/registration_camper.dart';
import 'package:summercamp/features/registration/domain/entities/registration_optional_choice.dart';

class Registration {
  final int registrationId;
  final int? camperId;
  final int? campId;
  final int? paymentId;
  final DateTime registrationCreateAt;
  final RegistrationStatus status;
  final int? price;
  final String campName;
  final String? campDescription;
  final String? campPlace;
  final String? campStartDate;
  final String? campEndDate;
  final int? appliedPromotionId;
  final String? promotionCode;
  final int? discount;
  final List<RegistrationCamper> campers;
  final List<RegistrationOptionalChoice>? optionalChoices;

  const Registration({
    required this.registrationId,
    this.camperId,
    this.campId,
    this.paymentId,
    required this.registrationCreateAt,
    required this.status,
    this.price,
    required this.campName,
    this.campDescription,
    this.campPlace,
    this.campStartDate,
    this.campEndDate,
    this.appliedPromotionId,
    this.promotionCode,
    this.discount,
    required this.campers,
    this.optionalChoices,
  });
}
