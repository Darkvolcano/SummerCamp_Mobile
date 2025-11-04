import 'package:summercamp/features/ai_chat/domain/repositories/ai_chat_repository.dart';

class SendChatMessage {
  final AIChatRepository repository;
  SendChatMessage(this.repository);

  Future<String> call(String content) {
    return repository.sendMessage(content);
  }
}
