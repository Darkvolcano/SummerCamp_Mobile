class Staff {
  final int userId;
  final String fullName;

  const Staff({required this.userId, required this.fullName});

  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(userId: json['userId'], fullName: json['fullName']);
  }

  Map<String, dynamic> toJson() {
    return {'userId': userId, 'fullName': fullName};
  }
}
