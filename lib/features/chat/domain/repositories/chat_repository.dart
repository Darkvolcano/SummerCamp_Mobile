import 'package:summercamp/features/chat/domain/entities/chat_message.dart';
import 'package:summercamp/features/chat/domain/entities/chat_room.dart';
import 'package:summercamp/features/chat/domain/entities/create_room_result.dart';

abstract class ChatRepository {
  Future<List<ChatRoom>> getMyRooms();
  Future<List<ChatMessage>> getMessagesByRoomId(int roomId);
  Future<ChatMessage> sendMessage(int roomId, String content);
  Future<CreateRoomResult> createOrGetPrivateRoom(int recipientUserId);
  Future<ChatRoom> getRoomDetails(int roomId);
}
