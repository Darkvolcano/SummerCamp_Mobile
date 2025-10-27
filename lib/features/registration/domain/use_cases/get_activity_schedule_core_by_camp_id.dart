import 'package:summercamp/features/registration/domain/entities/activity_schedule.dart';
import 'package:summercamp/features/registration/domain/repositories/registration_repository.dart';

class GetActivitySchedulesCoreByCampId {
  final RegistrationRepository repository;
  GetActivitySchedulesCoreByCampId(this.repository);

  Future<List<ActivitySchedule>> call(int campId) async {
    return await repository.getActivitySchedulesCoreByCampId(campId);
  }
}
