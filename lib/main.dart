import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/config/app_routes.dart';
import 'core/config/app_theme.dart';
import 'core/network/api_client.dart';

import 'features/auth/presentation/state/auth_provider.dart';
import 'features/auth/data/services/auth_api_service.dart';
import 'features/auth/data/repositories/user_repository_impl.dart';
import 'features/auth/domain/use_cases/login_user.dart';
import 'features/auth/domain/use_cases/register_user.dart';
import 'features/auth/domain/use_cases/get_user_profile.dart';

void main() {
  final apiClient = ApiClient();
  final authService = AuthApiService(apiClient);
  final userRepo = UserRepositoryImpl(authService);

  runApp(
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
        // ... các provider khác (Camp, Registration) của bạn
      ],
      child: const SummerCampApp(),
    ),
  );
}

class SummerCampApp extends StatelessWidget {
  const SummerCampApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Summer Camp',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
