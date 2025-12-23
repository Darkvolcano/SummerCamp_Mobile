import 'package:flutter/material.dart';
import 'package:summercamp/features/chat/data/models/chat_message_model.dart';
import 'package:summercamp/features/chat/data/services/signalr_service.dart';
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
  final SignalRService _signalRService = SignalRService();

  ChatProvider({
    required this.getMyRoomsUseCase,
    required this.getMessagesUseCase,
    required this.sendMessageUseCase,
    required this.createPrivateRoomUseCase,
  }) {
    _initSignalRListener();
  }

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

  Future<void> connectSignalR(String token) async {
    await _signalRService.initSignalR(token);
  }

  void _initSignalRListener() {
    _signalRService.onMessageReceived = (data) {
      print("DATA RAW FROM SIGNALR: $data");

      try {
        final newMessage = ChatMessageModel.fromJson(data);
        print("Parsed Message RoomID: ${newMessage.chatRoomId}");

        if (_selectedRoom != null &&
            _selectedRoom!.chatRoomId == newMessage.chatRoomId) {
          final exists = _currentMessages.any(
            (m) => m.messageId == newMessage.messageId,
          );

          if (!exists) {
            _currentMessages.add(newMessage);
            notifyListeners();
            print("MATCH ROOM! Added message to list.");
          } else {
            print("DUPLICATE MESSAGE IGNORED: ${newMessage.messageId}");
          }
        }

        loadMyRooms();
      } catch (e) {
        print("SignalR Parse Error: $e");
      }
    };
  }

  Future<void> loadMyRooms() async {
    try {
      _rooms = await getMyRoomsUseCase();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      print("Error loading rooms: $e");
    }
  }

  Future<void> selectRoom(ChatRoom room) async {
    _selectedRoom = room;
    _currentMessages = [];
    notifyListeners();

    try {
      print("Joining SignalR Room: ${room.chatRoomId}");
      await _signalRService.joinRoom(room.chatRoomId.toString());

      await _loadMessages(room.chatRoomId);
    } catch (e) {
      print("Error selectRoom: $e");
    }
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
      _currentMessages = [];

      print("Joining SignalR Room (Private): ${room.chatRoomId}");
      await _signalRService.joinRoom(room.chatRoomId.toString());

      await _loadMessages(result.chatRoomId);
      loadMyRooms();
    } catch (e) {
      _error = e.toString();
      print("Error selecting user: $e");
    } finally {
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

      final exists = _currentMessages.any(
        (m) => m.messageId == newMessage.messageId,
      );

      if (!exists) {
        _currentMessages.add(newMessage);
        notifyListeners();
      }

      loadMyRooms();
    } catch (e) {
      _error = e.toString();
      print("Error sending message: $e");
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }

  void clearSelection() {
    if (_selectedRoom != null) {
      _signalRService.leaveRoom(_selectedRoom!.chatRoomId.toString());
    }
    _selectedRoom = null;
    _currentMessages = [];
    notifyListeners();
  }
}
