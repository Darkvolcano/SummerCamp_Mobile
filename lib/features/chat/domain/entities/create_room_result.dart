class CreateRoomResult {
  final int chatRoomId;
  final bool isNewRoom;
  final String recipientName;
  final String recipientAvatar;
  final int recipientUserId;

  const CreateRoomResult({
    required this.chatRoomId,
    required this.isNewRoom,
    required this.recipientName,
    required this.recipientAvatar,
    required this.recipientUserId,
  });
}
