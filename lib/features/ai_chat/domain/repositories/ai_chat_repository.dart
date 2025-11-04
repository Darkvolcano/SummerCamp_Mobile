import 'package:summercamp/features/ai_chat/domain/entities/ai_chat_history.dart';
import 'package:summercamp/features/ai_chat/domain/entities/ai_chat_message.dart';
import 'package:summercamp/features/ai_chat/domain/entities/ai_chat_response.dart';

abstract class AIChatRepository {
  Future<List<AiChatHistory>> getHistory();
  Future<List<AiChatMessage>> getConversation(int conversationId);
  Future<AiChatResponse> sendMessage(int? conversationId, String message);
}
