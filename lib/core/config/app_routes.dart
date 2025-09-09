import 'package:flutter/material.dart';

// import các màn hình
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/profile_screen.dart';
import '../../features/camp/presentation/screens/camp_list_screen.dart';
import '../../features/registration/presentation/screens/registration_list_screen.dart';

class AppRoutes {
  // 🔹 Định nghĩa route name
  static const String login = '/login';
  static const String register = '/register';
  static const String profile = '/profile';
  static const String campList = '/camp-list';
  static const String registrationList = '/registration-list';

  // 🔹 Hàm generate route
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => ProfileScreen());
      case campList:
        return MaterialPageRoute(builder: (_) => CampListScreen());
      case registrationList:
        return MaterialPageRoute(builder: (_) => RegistrationListScreen());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text("404 - Page not found"))),
        );
    }
  }
}
