import 'package:flutter/foundation.dart';
import '../../domain/entities/user.dart';
import '../../domain/use_cases/login_user.dart';

class AuthProvider with ChangeNotifier {
  final LoginUser loginUser;

  User? _currentUser;
  bool _isLoading = false;

  AuthProvider(this.loginUser);

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentUser = await loginUser(email, password);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
