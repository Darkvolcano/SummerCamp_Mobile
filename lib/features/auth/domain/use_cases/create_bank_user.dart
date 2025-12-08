import 'package:summercamp/features/auth/domain/repositories/user_repository.dart';

class CreateBankUser {
  final UserRepository repository;
  CreateBankUser(this.repository);

  Future<Map<String, dynamic>> call({
    required String bankCode,
    required String bankName,
    required String bankNumber,
    required bool isPrimary,
  }) async {
    return await repository.createBankUser(
      bankCode: bankCode,
      bankName: bankName,
      bankNumber: bankNumber,
      isPrimary: isPrimary,
    );
  }
}
