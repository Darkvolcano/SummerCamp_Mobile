class TransportScheduleDriver {
  final int driverId;
  final String fullName;

  const TransportScheduleDriver({
    required this.driverId,
    required this.fullName,
  });

  factory TransportScheduleDriver.fromJson(Map<String, dynamic> json) {
    return TransportScheduleDriver(
      driverId: json['driverId'],
      fullName: json['fullName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'driverId': driverId, 'fullName': fullName};
  }
}
