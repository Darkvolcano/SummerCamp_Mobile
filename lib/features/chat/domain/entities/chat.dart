import 'package:summercamp/features/auth/data/models/user_model.dart';

class Chat {
  final int id;
  final int? chatRoomId;
  final int senderId;
  final int? receiverId;
  final String content;
  final DateTime createAt;
  final UserModel? sender;
  final UserModel? receiver;

  const Chat({
    required this.id,
    this.chatRoomId,
    required this.senderId,
    this.receiverId,
    required this.content,
    required this.createAt,
    this.sender,
    this.receiver,
  });
}
