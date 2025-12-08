import 'package:summercamp/features/livestream/domain/entities/livestream.dart';
import 'package:summercamp/features/livestream/domain/repositories/livestream_repository.dart';

class UpdateLivestreamRoomId {
  final LivestreamRepository repository;
  UpdateLivestreamRoomId(this.repository);

  Future<void> call(Livestream livestream) async {
    await repository.updateLivestreamRoomId(livestream);
  }
}
