import 'package:summercamp/features/ai_chat/data/services/ai_chat_api_service.dart';
import 'package:summercamp/features/ai_chat/domain/entities/ai_chat_history.dart';
import 'package:summercamp/features/ai_chat/domain/entities/ai_chat_message.dart';
import 'package:summercamp/features/ai_chat/domain/entities/ai_chat_response.dart';
import 'package:summercamp/features/ai_chat/domain/repositories/ai_chat_repository.dart';

class AIChatRepositoryImpl implements AIChatRepository {
  final AIChatApiService service;
  AIChatRepositoryImpl(this.service);

  @override
  Future<List<AiChatHistory>> getHistory() async {
    final list = await service.getChatHistory();
    return list
        .map((data) => AiChatHistory.fromJson(data as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<AiChatMessage>> getConversation(int conversationId) async {
    final list = await service.getConversation(conversationId);
    return list
        .map((data) => AiChatMessage.fromJson(data as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<AiChatResponse> sendMessage(
    int? conversationId,
    String message,
  ) async {
    final requestData = {"conversationId": conversationId, "message": message};

    final data = await service.sendMessage(data: requestData);
    return AiChatResponse.fromJson(data);
  }
}
