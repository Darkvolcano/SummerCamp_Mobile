import 'package:summercamp/features/ai_chat/domain/entities/ai_chat_response.dart';
import 'package:summercamp/features/ai_chat/domain/repositories/ai_chat_repository.dart';

class SendChatMessage {
  final AIChatRepository repository;
  SendChatMessage(this.repository);

  Future<AiChatResponse> call(int? conversationId, String message) {
    return repository.sendMessage(conversationId, message);
  }
}
