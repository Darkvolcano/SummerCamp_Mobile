import 'package:summercamp/features/ai_chat/domain/entities/ai_chat_history.dart';
import 'package:summercamp/features/ai_chat/domain/repositories/ai_chat_repository.dart';

class GetChatHistory {
  final AIChatRepository repository;
  GetChatHistory(this.repository);

  Future<List<AiChatHistory>> call() {
    return repository.getHistory();
  }
}
