class CampTypeModel {
  final String campTypeId;
  final String name;
  final bool isActive;

  CampTypeModel({
    required this.campTypeId,
    required this.name,
    required this.isActive,
  });

  factory CampTypeModel.fromJson(Map<String, dynamic> json) {
    return CampTypeModel(
      campTypeId: json['campTypeId'],
      name: json['name'],
      isActive: json['isActive'] ?? false,
    );
  }
}
