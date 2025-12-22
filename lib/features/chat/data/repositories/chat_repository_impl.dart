import 'package:summercamp/features/chat/data/models/chat_request_models.dart';
import 'package:summercamp/features/chat/data/services/chat_api_service.dart';
import 'package:summercamp/features/chat/domain/entities/chat_message.dart';
import 'package:summercamp/features/chat/domain/entities/chat_room.dart';
import 'package:summercamp/features/chat/domain/entities/create_room_result.dart';
import 'package:summercamp/features/chat/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatApiService apiService;

  ChatRepositoryImpl(this.apiService);

  @override
  Future<List<ChatRoom>> getMyRooms() async {
    return await apiService.getMyRooms();
  }

  @override
  Future<List<ChatMessage>> getMessagesByRoomId(int roomId) async {
    return await apiService.getMessagesByRoomId(roomId);
  }

  @override
  Future<ChatMessage> sendMessage(int roomId, String content) async {
    final request = SendMessageRequestModel(
      chatRoomId: roomId,
      content: content,
    );
    return await apiService.sendMessage(request);
  }

  @override
  Future<CreateRoomResult> createOrGetPrivateRoom(int recipientUserId) async {
    final request = CreatePrivateRoomRequestModel(
      recipientUserId: recipientUserId,
    );
    return await apiService.createOrGetPrivateRoom(request);
  }

  @override
  Future<ChatRoom> getRoomDetails(int roomId) async {
    return await apiService.getRoomDetails(roomId);
  }
}
