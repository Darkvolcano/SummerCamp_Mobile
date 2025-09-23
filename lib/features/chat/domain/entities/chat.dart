import 'package:summercamp/features/auth/data/models/user_model.dart';

class Chat {
  final int chatId;
  final int? chatRoomId;
  final int senderId;
  final int? receiverId;
  final String content;
  final DateTime createAt;
  final UserModel? sender;
  final UserModel? receiver;

  const Chat({
    required this.chatId,
    this.chatRoomId,
    required this.senderId,
    this.receiverId,
    required this.content,
    required this.createAt,
    this.sender,
    this.receiver,
  });
}
