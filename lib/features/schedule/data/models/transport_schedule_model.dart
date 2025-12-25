import 'package:summercamp/core/enum/transport_schedule_status.enum.dart';
import 'package:summercamp/features/schedule/domain/entities/transport_schedule.dart';
import 'package:summercamp/features/schedule/domain/entities/transport_schedule_camp.dart';
import 'package:summercamp/features/schedule/domain/entities/transport_schedule_driver.dart';
import 'package:summercamp/features/schedule/domain/entities/transport_schedule_route.dart';
import 'package:summercamp/features/schedule/domain/entities/transport_schedule_vehicle.dart';

class TransportScheduleModel extends TransportSchedule {
  const TransportScheduleModel({
    required super.transportScheduleId,
    required super.campName,
    required super.routeName,
    required super.driverFullName,
    required super.vehicleName,
    required super.date,
    required super.startTime,
    required super.endTime,
    super.actualStartTime,
    super.actualEndTime,
    required super.status,
    required super.transportType,
  });

  static TransportScheduleStatus _statusFromString(String statusString) {
    switch (statusString) {
      case 'Draft':
        return TransportScheduleStatus.Draft;
      case 'Rejected':
        return TransportScheduleStatus.Rejected;
      case 'NotYet':
        return TransportScheduleStatus.NotYet;
      case 'InProgress':
        return TransportScheduleStatus.InProgress;
      case 'Completed':
        return TransportScheduleStatus.Completed;
      case 'Canceled':
        return TransportScheduleStatus.Canceled;
      default:
        print("Warning: Unknown CampStatus string '$statusString'");
        return TransportScheduleStatus.Draft;
    }
  }

  factory TransportScheduleModel.fromJson(Map<String, dynamic> json) {
    final route = json['routeName'];
    final driver = json['driverFullName'];
    final vehicle = json['vehicleName'];
    final camp = json['campName'];

    return TransportScheduleModel(
      transportScheduleId: json['transportScheduleId'],
      campName: TransportScheduleCamp.fromJson(camp),
      routeName: TransportScheduleRoute.fromJson(route),
      driverFullName: TransportScheduleDriver.fromJson(driver),
      vehicleName: TransportScheduleVehicle.fromJson(vehicle),
      date: json['date'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      actualStartTime: json['actualStartTime'],
      actualEndTime: json['actualEndTime'],
      status: _statusFromString(json['status']),
      transportType: json['transportType'],
    );
  }

  Map<String, dynamic> toJson() => {
    'transportScheduleId': transportScheduleId,
    'campName': campName.toJson(),
    'routeName': routeName.toJson(),
    'driverFullName': driverFullName.toJson(),
    'vehicleName': vehicleName.toJson(),
    'date': date,
    'startTime': startTime,
    'endTime': endTime,
    'actualStartTime': actualStartTime,
    'actualEndTime': actualEndTime,
    'status': status,
    'transportType': transportType,
  };
}
