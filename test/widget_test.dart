import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/main.dart';
import 'package:summercamp/features/auth/presentation/state/auth_provider.dart';
import 'package:summercamp/features/auth/domain/use_cases/login_user.dart';
import 'package:summercamp/features/auth/domain/use_cases/get_user_profile.dart';
import 'package:summercamp/features/auth/domain/use_cases/register_user.dart';
import 'package:summercamp/features/auth/data/repositories/user_repository_impl.dart';
import 'package:summercamp/features/auth/data/services/auth_api_service.dart';
import 'package:summercamp/core/network/api_client.dart';

void main() {
  testWidgets('App loads login screen', (WidgetTester tester) async {
    final apiClient = ApiClient();
    final authService = AuthApiService(apiClient);
    final userRepo = UserRepositoryImpl(authService);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => AuthProvider(
              loginUser: LoginUser(userRepo),
              registerUser: RegisterUser(userRepo),
              getUserProfile: GetUserProfile(userRepo),
              repository: userRepo,
            ),
          ),
        ],
        child: const SummerCampApp(),
      ),
    );

    // Kiểm tra có AppBar title "Login"
    expect(
      find.descendant(of: find.byType(AppBar), matching: find.text("Login")),
      findsOneWidget,
    );

    // Kiểm tra có nút Login
    expect(find.widgetWithText(ElevatedButton, "Login"), findsOneWidget);
  });
}
