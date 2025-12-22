import 'package:summercamp/core/network/api_client.dart';
import '../models/chat_message_model.dart';
import '../models/chat_room_model.dart';
import '../models/chat_request_models.dart';
import '../models/create_room_response_model.dart';

class ChatApiService {
  final ApiClient client;

  ChatApiService(this.client);

  Future<ChatMessageModel> sendMessage(SendMessageRequestModel request) async {
    try {
      final response = await client.post(
        '/chat-rooms/send',
        data: request.toJson(),
      );
      return ChatMessageModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  Future<List<ChatRoomModel>> getMyRooms() async {
    try {
      final response = await client.get('/chat-rooms/my-rooms');
      if (response.data is List) {
        return (response.data as List)
            .map((e) => ChatRoomModel.fromJson(e))
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to get my rooms: $e');
    }
  }

  Future<List<ChatMessageModel>> getMessagesByRoomId(int roomId) async {
    try {
      final response = await client.get('/chat-rooms/$roomId/messages');
      if (response.data is List) {
        return (response.data as List)
            .map((e) => ChatMessageModel.fromJson(e))
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to get messages: $e');
    }
  }

  Future<CreateRoomResponseModel> createOrGetPrivateRoom(
    CreatePrivateRoomRequestModel request,
  ) async {
    try {
      final response = await client.post(
        '/chat-rooms/create-or-get-private',
        data: request.toJson(),
      );
      return CreateRoomResponseModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create/get private room: $e');
    }
  }

  Future<ChatRoomModel> getRoomDetails(int roomId) async {
    try {
      final response = await client.get('/chat-rooms/$roomId/details');
      return ChatRoomModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to get room details: $e');
    }
  }
}
