import 'package:summercamp/features/livestream/domain/entities/livestream.dart';

abstract class LivestreamRepository {
  Future<void> updateLivestreamRoomId(Livestream livestream);
}
