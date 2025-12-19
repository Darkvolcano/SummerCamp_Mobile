import 'package:summercamp/features/schedule/domain/entities/route.dart';
import 'package:summercamp/features/schedule/domain/repositories/schedule_repository.dart';

class GetRouteStopByRouteId {
  final ScheduleRepository repository;
  GetRouteStopByRouteId(this.repository);

  Future<List<Route>> call(int routeId) {
    return repository.getRouteStopByRouteId(routeId);
  }
}
