class BankUserModel {
  final int bankUserId;
  final int userId;
  final String bankCode;
  final String bankName;
  final String bankNumber;
  final bool isPrimary;
  final bool isActive;

  BankUserModel({
    required this.bankUserId,
    required this.userId,
    required this.bankCode,
    required this.bankName,
    required this.bankNumber,
    required this.isPrimary,
    required this.isActive,
  });

  factory BankUserModel.fromJson(Map<String, dynamic> json) {
    return BankUserModel(
      bankUserId: json['bankUserId'],
      userId: json['userId'],
      bankCode: json['bankCode'],
      bankName: json['bankName'],
      bankNumber: json['bankNumber'],
      isPrimary: json['isPrimary'] ?? false,
      isActive: json['isActive'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bankUserId': bankUserId,
      'userId': userId,
      'bankCode': bankCode,
      'bankName': bankName,
      'bankNumber': bankNumber,
      'isPrimary': isPrimary,
      'isActive': isActive,
    };
  }
}
