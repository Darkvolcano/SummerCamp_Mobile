class RegisterResponse {
  final int userId;
  final String message;

  RegisterResponse({required this.userId, required this.message});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      userId: json['userId'] as int,
      message: json['message'] as String,
    );
  }
}
