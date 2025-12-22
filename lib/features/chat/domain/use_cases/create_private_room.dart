import 'package:summercamp/features/chat/domain/entities/create_room_result.dart';
import 'package:summercamp/features/chat/domain/repositories/chat_repository.dart';

class CreatePrivateRoom {
  final ChatRepository repository;
  CreatePrivateRoom(this.repository);

  Future<CreateRoomResult> call(int recipientUserId) async {
    return await repository.createOrGetPrivateRoom(recipientUserId);
  }
}
