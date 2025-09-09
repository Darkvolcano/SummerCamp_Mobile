import 'package:summercamp/features/chat/domain/entities/chat.dart';

abstract class ChatRepository {
  Future<List<Chat>> getMessages();
}
