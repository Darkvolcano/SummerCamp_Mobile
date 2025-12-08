import 'package:summercamp/features/auth/domain/entities/bank_user.dart';
import 'package:summercamp/features/auth/domain/repositories/user_repository.dart';

class GetBankUsers {
  final UserRepository repository;
  GetBankUsers(this.repository);

  Future<List<BankUser>> call() async {
    return await repository.getBankUsers();
  }
}
