class TransportScheduleCamp {
  final int campId;
  final String name;

  const TransportScheduleCamp({required this.campId, required this.name});

  factory TransportScheduleCamp.fromJson(Map<String, dynamic> json) {
    return TransportScheduleCamp(campId: json['campId'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'campId': campId, 'name': name};
  }
}
