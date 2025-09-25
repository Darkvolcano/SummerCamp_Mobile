import 'package:flutter/material.dart';
import 'package:summercamp/features/ai_chat/presentation/screens/ai_chat_screen.dart';
import 'package:summercamp/features/auth/presentation/screens/login_screen.dart';
import 'package:summercamp/features/blog/domain/entities/blog.dart';
import 'package:summercamp/features/blog/presentation/screens/blog_detail_screen.dart';
import 'package:summercamp/features/blog/presentation/screens/blog_list_screen.dart';
import 'package:summercamp/features/camp/domain/entities/camp.dart';
import 'package:summercamp/features/camp/presentation/screens/attendance_screen.dart';
import 'package:summercamp/features/camp/presentation/screens/camp_detail_screen.dart';
import 'package:summercamp/features/camp/presentation/screens/camp_schedule_screen.dart';
import 'package:summercamp/features/camp/presentation/screens/camp_schedulle_detail_screen.dart';
import 'package:summercamp/features/camp/presentation/screens/upload_photo_screen.dart';
import 'package:summercamp/features/camper/domain/entities/camper.dart';
import 'package:summercamp/features/camper/presentation/screens/camper_create_screen.dart';
import 'package:summercamp/features/camper/presentation/screens/camper_detail_screen.dart';
import 'package:summercamp/features/camper/presentation/screens/camper_list_screen.dart';
import 'package:summercamp/features/camper/presentation/screens/camper_update_screen.dart';
import 'package:summercamp/features/home/presentation/screens/home_staff.dart';
import 'package:summercamp/features/profile/presentation/screens/profile_screen.dart';
import 'package:summercamp/features/auth/presentation/screens/register_screen.dart';
import 'package:summercamp/features/camp/presentation/screens/camp_list_screen.dart';
import 'package:summercamp/features/home/presentation/screens/home.dart';
import 'package:summercamp/features/registration/domain/entities/registration.dart';
import 'package:summercamp/features/registration/presentation/screens/registration_detail_screen.dart';
import 'package:summercamp/features/registration/presentation/screens/registration_form_screen.dart';
import 'package:summercamp/features/registration/presentation/screens/registration_list_screen.dart';
import 'package:summercamp/features/report/presentation/screens/report_form_screen.dart';
import 'package:summercamp/features/report/presentation/screens/report_list_screen.dart';

class AppRoutes {
  // Define route
  static const String login = '/login';
  static const String register = '/register';
  static const String verifyOTP = '/verify-otp'; // hiện tại chưa có
  static const String chat = '/chat'; // hiện tại chưa có
  static const String chatDetail = '/chat-detail'; // hiện tại chưa có
  static const String chatAI = '/chat-ai';
  static const String report = '/report'; // hiện tại chưa có
  static const String createReport = '/create-report'; // hiện tại chưa có
  static const String registrationDetail = '/registration-detail';
  static const String registrationForm = '/registration-form';
  static const String home = '/home';
  static const String staffHome = '/staff-home';
  static const String campSchedule = '/camp-schedule';
  static const String campScheduleDetail = '/camp-schedule-detail';
  static const String attendance = '/attendance';
  static const String campDetail = '/camp-detail';
  static const String camperList = '/camper-list';
  static const String camperDetail = '/camper-detail';
  static const String createCamper = '/create-camper';
  static const String updateCamper = '/update-camper';
  static const String registrationCancel =
      '/registration-cancel'; // hiện tại chưa có
  static const String blogList = '/blog';
  static const String blogDetail = '/blog-detail';
  static const String profile = '/profile';
  static const String campList = '/camp-list';
  static const String registrationList = '/registration-list';
  static const String uploadPhoto = '/upload-photo';
  static const String album = '/album'; // hiện tại chưa có

  // Generate route
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // final role = settings.arguments;

    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());

      case register:
        return MaterialPageRoute(builder: (_) => RegisterScreen());

      case home:
        return MaterialPageRoute(builder: (_) => const Home());

      case staffHome:
        return MaterialPageRoute(builder: (_) => const StaffHome());

      case campSchedule:
        return MaterialPageRoute(builder: (_) => const CampScheduleScreen());

      case campScheduleDetail:
        final camp = settings.arguments as Camp;
        return MaterialPageRoute(
          builder: (_) => CampScheduleDetailScreen(camp: camp),
        );

      case attendance:
        final args = settings.arguments as Map<String, dynamic>;
        final camp = args["camp"] as Camp;
        final campers = args["campers"] as List<Camper>;
        return MaterialPageRoute(
          builder: (_) => AttendanceScreen(campers: campers, camp: camp),
        );

      // Parent, Staff can use this screen
      case profile:
        return MaterialPageRoute(builder: (_) => ProfileScreen());

      case chatAI:
        return MaterialPageRoute(builder: (_) => AIChatScreen());

      case campList:
        // if (role == "Parent" || role == "Staff") {
        return MaterialPageRoute(builder: (_) => CampListScreen());
      // }
      // return _unauthorizedRoute();

      case blogList:
        // if (role == "Parent" || role == "Staff") {
        return MaterialPageRoute(builder: (_) => BlogListScreen());

      case registrationList:
        return MaterialPageRoute(builder: (_) => RegistrationListScreen());

      case registrationDetail:
        final registration = settings.arguments as Registration;
        return MaterialPageRoute(
          builder: (_) => RegistrationDetailScreen(registration: registration),
        );

      case campDetail:
        final camp = settings.arguments as Camp;
        return MaterialPageRoute(builder: (_) => CampDetailScreen(camp: camp));

      case blogDetail:
        final blog = settings.arguments as Blog;
        return MaterialPageRoute(builder: (_) => BlogDetailScreen(blog: blog));

      case registrationForm:
        final camp = settings.arguments as Camp;
        return MaterialPageRoute(
          builder: (_) => RegistrationFormScreen(camp: camp),
        );

      case camperList:
        return MaterialPageRoute(builder: (_) => CamperListScreen());

      case uploadPhoto:
        final camp = settings.arguments as Camp;
        return MaterialPageRoute(builder: (_) => UploadPhotoScreen(camp: camp));

      case camperDetail:
        final camper = settings.arguments as Camper;
        return MaterialPageRoute(
          builder: (_) => CamperDetailScreen(camper: camper),
        );

      case createCamper:
        return MaterialPageRoute(builder: (_) => CamperCreateScreen());

      case updateCamper:
        final camper = settings.arguments as Camper;
        return MaterialPageRoute(
          builder: (_) => CamperUpdateScreen(camper: camper),
        );

      case report:
        return MaterialPageRoute(builder: (_) => ReportListScreen());

      case createReport:
        return MaterialPageRoute(builder: (_) => ReportCreateScreen());
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

  // static Route<dynamic> _unauthorizedRoute() {
  //   return MaterialPageRoute(
  //     builder: (context) => Scaffold(
  //       body: Center(
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             const Text("You don’t have permission to access this page"),
  //             const SizedBox(height: 12),
  //             ElevatedButton(
  //               onPressed: () => Navigator.pop(context),
  //               child: const Text("Go back"),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
