class CampPromotion {
  final int id;
  final String name;
  final double percent;
  final double maxDiscountAmount;
  final int maxUsageCount;

  const CampPromotion({
    required this.id,
    required this.name,
    required this.percent,
    required this.maxDiscountAmount,
    required this.maxUsageCount,
  });

  factory CampPromotion.fromJson(Map<String, dynamic> json) {
    return CampPromotion(
      id: json['id'],
      name: json['name'],
      percent: json['percent'],
      maxDiscountAmount: json['maxDiscountAmount'],
      maxUsageCount: json['maxUsageCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'percent': percent,
      'maxDiscountAmount': maxDiscountAmount,
      'maxUsageCount': maxUsageCount,
    };
  }
}
