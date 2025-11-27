class TransportScheduleVehicle {
  final int vehicleId;
  final String vehicleName;

  const TransportScheduleVehicle({
    required this.vehicleId,
    required this.vehicleName,
  });

  factory TransportScheduleVehicle.fromJson(Map<String, dynamic> json) {
    return TransportScheduleVehicle(
      vehicleId: json['vehicleId'],
      vehicleName: json['vehicleName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'vehicleId': vehicleId, 'vehicleName': vehicleName};
  }
}
