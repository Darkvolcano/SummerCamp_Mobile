import 'package:summercamp/core/enum/transport_schedule_status.enum.dart';
import 'package:summercamp/features/schedule/domain/entities/transport_schedule_driver.dart';
import 'package:summercamp/features/schedule/domain/entities/transport_schedule_route.dart';
import 'package:summercamp/features/schedule/domain/entities/transport_schedule_vehicle.dart';

class TransportSchedule {
  final int transportScheduleId;
  final TransportScheduleRoute routeName;
  final TransportScheduleDriver driverFullName;
  final TransportScheduleVehicle vehicleName;
  final String date;
  final String startTime;
  final String endTime;
  final String? actualStartTime;
  final String? actualEndTime;
  final TransportScheduleStatus status;

  const TransportSchedule({
    required this.transportScheduleId,
    required this.routeName,
    required this.driverFullName,
    required this.vehicleName,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.actualStartTime,
    this.actualEndTime,
    required this.status,
  });
}
