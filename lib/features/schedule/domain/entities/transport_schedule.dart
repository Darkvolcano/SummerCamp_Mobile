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
  final String actualStartTime;
  final String actualEndTime;
  final int status;

  const TransportSchedule({
    required this.transportScheduleId,
    required this.routeName,
    required this.driverFullName,
    required this.vehicleName,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.actualStartTime,
    required this.actualEndTime,
    required this.status,
  });
}
