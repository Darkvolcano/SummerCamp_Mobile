import 'package:summercamp/features/ai_chat/data/services/ai_chat_api_service.dart';
import 'package:summercamp/features/ai_chat/domain/repositories/ai_chat_repository.dart';

class AIChatRepositoryImpl implements AIChatRepository {
  final AIChatApiService service;
  AIChatRepositoryImpl(this.service);

  @override
  Future<String> sendMessage(String content) async {
    final requestData = {
      "messages": [
        {"role": "user", "content": content},
      ],
    };

    final data = await service.sendMessage(data: requestData);

    if (data.containsKey('textResponse') && data['textResponse'] != null) {
      return data['textResponse'] as String;
    }

    throw Exception("Không nhận được phản hồi hợp lệ từ AI");
  }
}
