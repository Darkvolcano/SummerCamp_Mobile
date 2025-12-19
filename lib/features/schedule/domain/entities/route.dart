import 'package:summercamp/features/schedule/domain/entities/location.dart';
import 'package:summercamp/features/schedule/domain/entities/transport_schedule_route.dart';

class Route {
  final int routeStopId;
  final TransportScheduleRoute route;
  final Location location;
  final int stopOrder;
  final int estimatedTime;
  final String status;

  const Route({
    required this.routeStopId,
    required this.route,
    required this.location,
    required this.stopOrder,
    required this.estimatedTime,
    required this.status,
  });
}
