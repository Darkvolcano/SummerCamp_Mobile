import 'package:summercamp/features/chat/domain/entities/chat_message.dart';
import 'package:summercamp/features/chat/domain/repositories/chat_repository.dart';

class SendMessage {
  final ChatRepository repository;
  SendMessage(this.repository);

  Future<ChatMessage> call(int roomId, String content) async {
    return await repository.sendMessage(roomId, content);
  }
}
