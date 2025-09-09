class CampTypeModel {
  final String id;
  final String name;
  final bool isActive;

  CampTypeModel({required this.id, required this.name, required this.isActive});

  factory CampTypeModel.fromJson(Map<String, dynamic> json) {
    return CampTypeModel(
      id: json['id'],
      name: json['name'],
      isActive: json['isActive'] ?? false,
    );
  }
}
