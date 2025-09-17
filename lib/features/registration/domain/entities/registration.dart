class Registration {
  final int id;
  final int camperId;
  final int campId;
  final int paymentId;
  final DateTime registrationCreateAt;
  final String status;
  final int price;
  final String campName;
  final String campDescription;
  final String campPlace;
  final DateTime campStartDate;
  final DateTime campEndDate;
  final int? promotionId;
  final String? promotionCode;
  final int? discount;

  const Registration({
    required this.id,
    required this.camperId,
    required this.campId,
    required this.paymentId,
    required this.registrationCreateAt,
    required this.status,
    required this.price,
    required this.campName,
    required this.campDescription,
    required this.campPlace,
    required this.campStartDate,
    required this.campEndDate,
    this.promotionId,
    this.promotionCode,
    this.discount,
  });
}
