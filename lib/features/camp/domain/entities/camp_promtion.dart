class CampPromotion {
  final int id;
  final String name;

  const CampPromotion({required this.id, required this.name});

  factory CampPromotion.fromJson(Map<String, dynamic> json) {
    return CampPromotion(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
