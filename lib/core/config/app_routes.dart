import 'package:flutter/material.dart';
import 'package:summercamp/features/auth/presentation/screens/login_screen.dart';
import 'package:summercamp/features/profile/presentation/screens/profile_screen.dart';
import 'package:summercamp/features/auth/presentation/screens/register_screen.dart';
import 'package:summercamp/features/camp/presentation/screens/camp_list_screen.dart';
import 'package:summercamp/features/home/presentation/screens/home.dart';
import 'package:summercamp/features/registration/presentation/screens/registration_list_screen.dart';

class AppRoutes {
  // Define route
  static const String login = '/login';
  static const String register = '/register';
  static const String verifyOTP = '/verify-otp'; // hiện tại chưa có
  static const String chat = '/chat'; // hiện tại chưa có
  static const String chatDetail = '/chat-detail'; // hiện tại chưa có
  static const String chatAI = '/chat-ai'; // hiện tại chưa có
  static const String report = '/report'; // hiện tại chưa có
  static const String registrationDetail = '/registration-detail';
  static const String home = '/home';
  static const String campDetail = '/camp-detail';
  static const String camperList = '/camper-list'; // hiện tại chưa có
  static const String formRegisterCamper =
      '/form-register-camper'; // hiện tại chưa có
  static const String registrationCancel =
      '/registration-cancel'; // hiện tại chưa có
  static const String blog = '/blog'; // hiện tại chưa có
  static const String blogDetail = '/blog-detail'; // hiện tại chưa có
  static const String profile = '/profile';
  static const String campList = '/camp-list';
  static const String registrationList = '/registration-list';
  static const String album = '/album'; // hiện tại chưa có

  // Generate route
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final role = settings.arguments as String?;

    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const Home());

      // Parent, Staff can use this screen
      case profile:
        return MaterialPageRoute(builder: (_) => ProfileScreen());

      case campList:
        if (role == "Parent" || role == "Staff") {
          return MaterialPageRoute(builder: (_) => CampListScreen());
        }
        return _unauthorizedRoute();

      case registrationList:
        if (role == "Parent" || role == "Staff") {
          return MaterialPageRoute(builder: (_) => RegistrationListScreen());
        }
        return _unauthorizedRoute();

      // Ex: staff only
      // case '/staff-dashboard':
      //   if (role == "Staff") {
      //     return MaterialPageRoute(builder: (_) => StaffDashboardScreen());
      //   }
      //   return _unauthorizedRoute();

      default:
        return _notFoundRoute();
    }
  }

  static Route<dynamic> _unauthorizedRoute() {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("You don’t have permission to access this page"),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Go back"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Route<dynamic> _notFoundRoute() {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Something went wrong"),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Go back"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
