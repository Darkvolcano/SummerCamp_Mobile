import 'package:summercamp/features/chat/domain/entities/chat_room.dart';
import 'package:summercamp/features/chat/domain/repositories/chat_repository.dart';

class GetMyRooms {
  final ChatRepository repository;
  GetMyRooms(this.repository);

  Future<List<ChatRoom>> call() async {
    return await repository.getMyRooms();
  }
}
