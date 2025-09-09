import 'package:summercamp/features/chat/data/models/chat_model.dart';
import 'package:summercamp/features/chat/data/services/chat_api_service.dart';
import 'package:summercamp/features/chat/domain/entities/chat.dart';
import 'package:summercamp/features/chat/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatApiService service;
  ChatRepositoryImpl(this.service);

  @override
  Future<List<Chat>> getMessages() async {
    final list = await service.fetchMessages();
    return list.map((e) => ChatModel.fromJson(e)).toList();
  }
}
