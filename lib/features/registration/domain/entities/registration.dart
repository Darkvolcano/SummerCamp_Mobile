class Registration {
  final int registrationId;
  final int camperId;
  final int campId;
  final int paymentId;
  final DateTime registrationCreateAt;
  final String status;
  final int price;
  final String? campName;
  final String? campDescription;
  final String? campPlace;
  final String? campStartDate;
  final String? campEndDate;
  final int appliedPromotionId;
  final String? promotionCode;
  final int? discount;

  const Registration({
    required this.registrationId,
    required this.camperId,
    required this.campId,
    required this.paymentId,
    required this.registrationCreateAt,
    required this.status,
    required this.price,
    this.campName,
    this.campDescription,
    this.campPlace,
    this.campStartDate,
    this.campEndDate,
    required this.appliedPromotionId,
    this.promotionCode,
    this.discount,
  });
}
