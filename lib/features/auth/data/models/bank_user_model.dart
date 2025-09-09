class BankUserModel {
  final String id;
  final String bankCode;
  final String bankName;
  final String bankNumber;
  final bool isPrimary;

  BankUserModel({
    required this.id,
    required this.bankCode,
    required this.bankName,
    required this.bankNumber,
    required this.isPrimary,
  });

  factory BankUserModel.fromJson(Map<String, dynamic> json) {
    return BankUserModel(
      id: json['userId'],
      bankCode: json['bankCode'],
      bankName: json['bankName'],
      bankNumber: json['bankNumber'],
      isPrimary: json['isPrimary'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': id,
      'bankCode': bankCode,
      'bankName': bankName,
      'bankNumber': bankNumber,
      'isPrimary': isPrimary,
    };
  }
}
