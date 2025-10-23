class CampCampType {
  final int id;
  final String name;

  const CampCampType({required this.id, required this.name});

  factory CampCampType.fromJson(Map<String, dynamic> json) {
    return CampCampType(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
