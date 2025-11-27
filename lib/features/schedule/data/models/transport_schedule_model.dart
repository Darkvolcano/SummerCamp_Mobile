import 'package:summercamp/features/schedule/domain/entities/transport_schedule.dart';
import 'package:summercamp/features/schedule/domain/entities/transport_schedule_driver.dart';
import 'package:summercamp/features/schedule/domain/entities/transport_schedule_route.dart';
import 'package:summercamp/features/schedule/domain/entities/transport_schedule_vehicle.dart';

class TransportScheduleModel extends TransportSchedule {
  const TransportScheduleModel({
    required super.transportScheduleId,
    required super.routeName,
    required super.driverFullName,
    required super.vehicleName,
    required super.date,
    required super.startTime,
    required super.endTime,
    required super.actualStartTime,
    required super.actualEndTime,
    required super.status,
  });

  factory TransportScheduleModel.fromJson(Map<String, dynamic> json) {
    final route = json['routeName'];
    final driver = json['driverFullName'];
    final vehicle = json['vehicleName'];

    return TransportScheduleModel(
      transportScheduleId: json['transportScheduleId'],
      routeName: TransportScheduleRoute.fromJson(route),
      driverFullName: TransportScheduleDriver.fromJson(driver),
      vehicleName: TransportScheduleVehicle.fromJson(vehicle),
      date: json['date'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      actualStartTime: json['actualStartTime'],
      actualEndTime: json['actualEndTime'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
    'transportScheduleId': transportScheduleId,
    'routeName': routeName.toJson(),
    'driverFullName': driverFullName.toJson(),
    'vehicleName': vehicleName.toJson(),
    'date': date,
    'startTime': startTime,
    'endTime': endTime,
    'actualStartTime': actualStartTime,
    'actualEndTime': actualEndTime,
    'status': status,
  };
}
