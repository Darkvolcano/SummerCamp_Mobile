import 'package:summercamp/features/report/domain/repositories/report_repository.dart';

class CreateTransportReport {
  final ReportRepository repository;
  CreateTransportReport(this.repository);

  Future<Map<String, dynamic>> call({
    required int campId,
    required int camperId,
    required int transportScheduleId,
    required String note,
    required String imageUrl,
  }) async {
    return await repository.createTransportReport(
      campId: campId,
      camperId: camperId,
      transportScheduleId: transportScheduleId,
      note: note,
      imageUrl: imageUrl,
    );
  }
}
