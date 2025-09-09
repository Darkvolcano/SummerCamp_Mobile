class CampTypeModel {
  final String id;
  final String name;

  CampTypeModel({required this.id, required this.name});

  factory CampTypeModel.fromJson(Map<String, dynamic> json) {
    return CampTypeModel(id: json['id'], name: json['name']);
  }
}
