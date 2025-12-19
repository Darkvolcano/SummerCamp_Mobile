import 'package:summercamp/features/schedule/domain/entities/location.dart';
import 'package:summercamp/features/schedule/domain/entities/route.dart';
import 'package:summercamp/features/schedule/domain/entities/transport_schedule_route.dart';

class RouteModel extends Route {
  const RouteModel({
    required super.routeStopId,
    required super.route,
    required super.location,
    required super.stopOrder,
    required super.estimatedTime,
    required super.status,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    final route = json['route'];
    final location = json['location'];

    return RouteModel(
      routeStopId: json['routeStopId'],
      route: TransportScheduleRoute.fromJson(route),
      location: Location.fromJson(location),
      stopOrder: json['stopOrder'],
      estimatedTime: json['estimatedTime'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
    'routeStopId': routeStopId,
    'route': route.toJson(),
    'location': location.toJson(),
    'stopOrder': stopOrder,
    'estimatedTime': estimatedTime,
    'status': status,
  };
}
