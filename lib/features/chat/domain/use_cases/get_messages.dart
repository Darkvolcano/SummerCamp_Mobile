import 'package:summercamp/features/chat/domain/entities/chat.dart';
import 'package:summercamp/features/chat/domain/repositories/chat_repository.dart';

class GetMessages {
  final ChatRepository repository;
  GetMessages(this.repository);

  Future<List<Chat>> call() async {
    return await repository.getMessages();
  }
}
