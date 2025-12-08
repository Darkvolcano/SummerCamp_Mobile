class BankUser {
  final int bankUserId;
  final int userId;
  final String bankCode;
  final String bankName;
  final String bankNumber;
  final bool isPrimary;
  final bool isActive;

  const BankUser({
    required this.bankUserId,
    required this.userId,
    required this.bankCode,
    required this.bankName,
    required this.bankNumber,
    required this.isPrimary,
    required this.isActive,
  });
}
