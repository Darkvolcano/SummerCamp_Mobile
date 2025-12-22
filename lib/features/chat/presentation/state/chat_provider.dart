import 'package:flutter/material.dart';
import 'package:summercamp/features/chat/domain/entities/chat_message.dart';
import 'package:summercamp/features/chat/domain/entities/chat_room.dart';
import 'package:summercamp/features/chat/domain/use_cases/create_private_room.dart';
import 'package:summercamp/features/chat/domain/use_cases/get_messages.dart';
import 'package:summercamp/features/chat/domain/use_cases/get_my_rooms.dart';
import 'package:summercamp/features/chat/domain/use_cases/send_message.dart';

class ChatProvider extends ChangeNotifier {
  final GetMyRooms getMyRoomsUseCase;
  final GetMessages getMessagesUseCase;
  final SendMessage sendMessageUseCase;
  final CreatePrivateRoom createPrivateRoomUseCase;

  ChatProvider({
    required this.getMyRoomsUseCase,
    required this.getMessagesUseCase,
    required this.sendMessageUseCase,
    required this.createPrivateRoomUseCase,
  });

  List<ChatRoom> _rooms = [];
  List<ChatMessage> _currentMessages = [];
  ChatRoom? _selectedRoom;
  bool _isLoading = false;
  bool _isSending = false;
  String? _error;

  List<ChatRoom> get rooms => _rooms;
  List<ChatMessage> get currentMessages => _currentMessages;
  ChatRoom? get selectedRoom => _selectedRoom;
  bool get isLoading => _isLoading;
  bool get isSending => _isSending;
  String? get error => _error;

  Future<void> loadMyRooms() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _rooms = await getMyRoomsUseCase();
    } catch (e) {
      _error = e.toString();
      print("Error loading rooms: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> selectRoom(ChatRoom room) async {
    _selectedRoom = room;
    await _loadMessages(room.chatRoomId);
  }

  Future<void> selectUserForChat(int recipientId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await createPrivateRoomUseCase(recipientId);

      final room = ChatRoom(
        chatRoomId: result.chatRoomId,
        name: result.recipientName,
        type: 0,
        avatarUrl: result.recipientAvatar,
      );

      _selectedRoom = room;

      await _loadMessages(result.chatRoomId);

      loadMyRooms();
    } catch (e) {
      _error = e.toString();
      print("Error selecting user: $e");
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadMessages(int roomId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _currentMessages = await getMessagesUseCase(roomId);
    } catch (e) {
      print("Error loading messages: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendMessage(String content) async {
    if (_selectedRoom == null || content.trim().isEmpty) return;

    _isSending = true;
    notifyListeners();

    try {
      final newMessage = await sendMessageUseCase(
        _selectedRoom!.chatRoomId,
        content,
      );

      _currentMessages.add(newMessage);
    } catch (e) {
      _error = e.toString();
      print("Error sending message: $e");
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }

  void clearSelection() {
    _selectedRoom = null;
    _currentMessages = [];
    notifyListeners();
  }
}
