import 'package:summercamp/features/livestream/data/models/livestream_model.dart';
import 'package:summercamp/features/livestream/data/services/livestream_api_service.dart';
import 'package:summercamp/features/livestream/domain/entities/livestream.dart';
import 'package:summercamp/features/livestream/domain/repositories/livestream_repository.dart';

class LivestreamRepositoryImpl implements LivestreamRepository {
  final LivestreamApiService service;
  LivestreamRepositoryImpl(this.service);

  @override
  Future<void> updateLivestreamRoomId(Livestream livestream) async {
    final livestreamModel = LivestreamModel(
      livestreamId: livestream.livestreamId,
      roomId: livestream.roomId,
    );

    final data = livestreamModel.toJson();

    await service.updateLivestreamRoomId(livestream.livestreamId, data);
  }
}
