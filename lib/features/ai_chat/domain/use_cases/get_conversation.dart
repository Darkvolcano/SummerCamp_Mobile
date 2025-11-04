import 'package:summercamp/features/ai_chat/domain/entities/ai_chat_message.dart';
import 'package:summercamp/features/ai_chat/domain/repositories/ai_chat_repository.dart';

class GetConversation {
  final AIChatRepository repository;
  GetConversation(this.repository);

  Future<List<AiChatMessage>> call(int conversationId) {
    return repository.getConversation(conversationId);
  }
}
