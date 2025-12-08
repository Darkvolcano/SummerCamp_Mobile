import 'package:summercamp/features/auth/domain/entities/bank_user.dart';

class BankUserModel extends BankUser {
  const BankUserModel({
    required super.bankUserId,
    required super.userId,
    required super.bankCode,
    required super.bankName,
    required super.bankNumber,
    required super.isPrimary,
    required super.isActive,
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
