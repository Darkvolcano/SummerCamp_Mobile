import 'package:flutter/material.dart';
import 'package:summercamp/features/ai_chat/presentation/screens/ai_chat_screen.dart';
import 'package:summercamp/features/attendance/presentation/screens/driver_attendance_screen.dart';
import 'package:summercamp/features/attendance/presentation/screens/staff_transport_schedule_attendance_screen.dart';
import 'package:summercamp/features/auth/presentation/screens/driver_register_screen.dart';
import 'package:summercamp/features/auth/presentation/screens/forgot_password_email_screen.dart';
import 'package:summercamp/features/auth/presentation/screens/forgot_password_otp_screen.dart';
import 'package:summercamp/features/auth/presentation/screens/login_screen.dart';
import 'package:summercamp/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:summercamp/features/auth/presentation/screens/verify_otp_screen.dart';
import 'package:summercamp/features/blog/domain/entities/blog.dart';
import 'package:summercamp/features/blog/presentation/screens/blog_detail_screen.dart';
import 'package:summercamp/features/blog/presentation/screens/blog_list_screen.dart';
import 'package:summercamp/features/camp/domain/entities/camp.dart';
import 'package:summercamp/features/chat/presentation/screens/chat_detail_screen.dart';
import 'package:summercamp/features/chat/presentation/screens/chat_list_screen.dart';
import 'package:summercamp/features/home/presentation/screens/home_driver.dart';
import 'package:summercamp/features/profile/presentation/screens/profile_driver_screen.dart';
import 'package:summercamp/features/profile/presentation/screens/profile_staff_screen.dart';
import 'package:summercamp/features/registration/presentation/screens/create_bank_user_screen.dart';
import 'package:summercamp/features/registration/presentation/screens/refund_registration_screen.dart';
import 'package:summercamp/features/schedule/domain/entities/schedule.dart';
import 'package:summercamp/features/attendance/presentation/screens/attendance_screen.dart';
import 'package:summercamp/features/camp/presentation/screens/camp_detail_screen.dart';
import 'package:summercamp/features/schedule/domain/entities/transport_schedule.dart';
import 'package:summercamp/features/schedule/presentation/screens/driver_schedule_screen.dart';
import 'package:summercamp/features/schedule/presentation/screens/staff_schedule_screen.dart';
import 'package:summercamp/features/schedule/presentation/screens/staff_schedulle_detail_screen.dart';
import 'package:summercamp/features/camp/presentation/screens/camp_search_screen.dart';
import 'package:summercamp/features/attendance/presentation/screens/face_recognition_attendance_screen.dart';
import 'package:summercamp/features/album/presentation/screens/upload_photo_screen.dart';
import 'package:summercamp/features/camper/domain/entities/camper.dart';
import 'package:summercamp/features/camper/presentation/screens/camper_create_screen.dart';
import 'package:summercamp/features/camper/presentation/screens/camper_detail_screen.dart';
import 'package:summercamp/features/camper/presentation/screens/camper_list_screen.dart';
import 'package:summercamp/features/camper/presentation/screens/camper_update_screen.dart';
import 'package:summercamp/features/home/presentation/screens/home_staff.dart';
import 'package:summercamp/features/livestream/presentation/screens/join_screen.dart';
import 'package:summercamp/features/profile/presentation/screens/profile_screen.dart';
import 'package:summercamp/features/auth/presentation/screens/register_screen.dart';
import 'package:summercamp/features/camp/presentation/screens/camp_list_screen.dart';
import 'package:summercamp/features/home/presentation/screens/home.dart';
import 'package:summercamp/features/registration/presentation/screens/payment_failure_screen.dart';
import 'package:summercamp/features/registration/presentation/screens/payment_success_screen.dart';
import 'package:summercamp/features/registration/presentation/screens/registration_detail_screen.dart';
import 'package:summercamp/features/registration/presentation/screens/registration_failure_screen.dart';
import 'package:summercamp/features/registration/presentation/screens/registration_form_screen.dart';
import 'package:summercamp/features/registration/presentation/screens/registration_list_screen.dart';
import 'package:summercamp/features/registration/presentation/screens/registration_success_screen.dart';
import 'package:summercamp/features/report/presentation/screens/report_form_screen.dart';
import 'package:summercamp/features/report/presentation/screens/report_list_screen.dart';
import 'package:summercamp/features/schedule/presentation/screens/staff_transport_schedule_screen.dart';

class AppRoutes {
  // Define route
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPasswordEmail = '/forgot-password-email';
  static const String forgotPasswordOTP = '/forgot-password-otp';
  static const String resetPassword = '/reset-password';
  static const String verifyOTP = '/verify-otp';
  static const String campSearch = '/camp-search';
  static const String chat = '/chat';
  static const String chatDetail = '/chat-detail';
  static const String staffChat = '/staff-chat';
  static const String staffChatDetail = '/staff-chat-detail';
  static const String chatAI = '/chat-ai';
  static const String joinLivestream = '/join-livestream';
  static const String report = '/report';
  static const String createReport = '/create-report';
  static const String registrationDetail = '/registration-detail';
  static const String registrationForm = '/registration-form';
  static const String home = '/home';
  static const String staffHome = '/staff-home';
  static const String staffSchedule = '/staff-schedule';
  static const String staffScheduleDetail = '/staff-schedule-detail';
  static const String staffTransportSchedule = '/staff-transport-schedule';
  static const String staffTransportScheduleAttendance =
      '/staff-transport-schedule-attendance';
  static const String attendance = '/attendance';
  static const String campDetail = '/camp-detail';
  static const String camperList = '/camper-list';
  static const String camperDetail = '/camper-detail';
  static const String createCamper = '/create-camper';
  static const String updateCamper = '/update-camper';
  static const String registrationCancel =
      '/registration-cancel'; // hiện tại chưa có
  static const String blogList = '/blog-list';
  static const String blogDetail = '/blog-detail';
  static const String profile = '/profile';
  static const String staffProfile = '/staff-profile';
  static const String campList = '/camp-list';
  static const String registrationList = '/registration-list';
  static const String uploadPhoto = '/upload-photo';
  static const String registrationSuccess = '/registration-success';
  static const String registrationFailure = '/registration-failure';
  static const String paymentHost = 'payment';
  static const String paymentSuccess = '/success';
  static const String paymentFailure = '/failure';
  static const String album = '/album'; // hiện tại chưa có
  static const String feedbackForm = '/feedback-form';
  static const String faceRecognitionAttendance =
      '/face-recognition-attendance';
  static const String driverRegister = '/driver-register';
  static const String driverHome = '/driver-home';
  static const String driverSchedule = '/driver-schedule';
  static const String driverScheduleDetail = '/driver-schedule-detail';
  static const String driverProfile = '/driver-profile';
  static const String driverAttendance = '/driver-attendance';
  static const String refundRegistration = '/refund-registration';
  static const String createBankUser = '/create-bank-user';

  // Generate route
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final Uri uri = Uri.parse(settings.name ?? '');

    if (uri.path == paymentSuccess) {
      final orderCode = uri.queryParameters['orderCode'] ?? 'N/A';
      return MaterialPageRoute(
        builder: (_) => PaymentSuccessScreen(orderCode: orderCode),
        settings: settings,
      );
    }

    if (uri.path == paymentFailure) {
      final orderCode = uri.queryParameters['orderCode'] ?? 'N/A';
      return MaterialPageRoute(
        builder: (_) => PaymentFailedScreen(orderCode: orderCode),
        settings: settings,
      );
    }

    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());

      case register:
        return MaterialPageRoute(builder: (_) => RegisterScreen());

      case forgotPasswordEmail:
        return MaterialPageRoute(builder: (_) => ForgotPasswordEmailScreen());

      case forgotPasswordOTP:
        final email = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ForgotPasswordOtpScreen(email: email),
        );

      case resetPassword:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ResetPasswordScreen(),
        );

      case verifyOTP:
        final email = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => VerifyOtpScreen(email: email));

      case campSearch:
        return MaterialPageRoute(builder: (_) => const CampSearchScreen());

      case home:
        return MaterialPageRoute(builder: (_) => const Home());

      case staffHome:
        return MaterialPageRoute(builder: (_) => const StaffHome());

      case driverHome:
        return MaterialPageRoute(builder: (_) => const DriverHome());

      case joinLivestream:
        return MaterialPageRoute(builder: (_) => JoinScreen());

      case staffSchedule:
        return MaterialPageRoute(builder: (_) => const StaffScheduleScreen());

      case staffScheduleDetail:
        final schedule = settings.arguments as Schedule;
        return MaterialPageRoute(
          builder: (_) => StaffScheduleDetailScreen(schedule: schedule),
        );

      case staffTransportSchedule:
        return MaterialPageRoute(
          builder: (_) => const StaffTransportScheduleScreen(),
        );

      case staffTransportScheduleAttendance:
        final schedule = settings.arguments as TransportSchedule;
        return MaterialPageRoute(
          builder: (_) =>
              StaffTransportScheduleAttedanceScreen(schedule: schedule),
        );

      case driverSchedule:
        return MaterialPageRoute(builder: (_) => const DriverScheduleScreen());

      case attendance:
        final args = settings.arguments as Map<String, dynamic>;
        final schedule = args["schedule"] as Schedule;
        final campers = args["campers"] as List<Camper>;
        return MaterialPageRoute(
          builder: (_) =>
              AttendanceScreen(campers: campers, schedule: schedule),
        );

      case profile:
        return MaterialPageRoute(builder: (_) => ProfileScreen());

      case staffProfile:
        return MaterialPageRoute(builder: (_) => const StaffProfileScreen());

      case driverProfile:
        return MaterialPageRoute(builder: (_) => const DriverProfileScreen());

      case chatAI:
        return MaterialPageRoute(builder: (_) => AIChatScreen());

      case chat:
        return MaterialPageRoute(builder: (_) => const ChatListScreen());

      case chatDetail:
        return MaterialPageRoute(builder: (_) => const ChatDetailScreen());

      case campList:
        return MaterialPageRoute(builder: (_) => CampListScreen());

      case blogList:
        // if (role == "Parent" || role == "Staff") {
        return MaterialPageRoute(builder: (_) => BlogListScreen());

      case registrationList:
        return MaterialPageRoute(builder: (_) => RegistrationListScreen());

      case registrationDetail:
        final registrationId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) =>
              RegistrationDetailScreen(registrationId: registrationId),
        );

      case refundRegistration:
        final registrationId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) =>
              RefundRegistrationScreen(registrationId: registrationId),
        );

      case createBankUser:
        return MaterialPageRoute(builder: (_) => CreateBankUserScreen());

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
        final schedule = settings.arguments as Schedule;
        return MaterialPageRoute(
          builder: (_) => UploadPhotoScreen(schedule: schedule),
        );

      case camperDetail:
        final camperId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => CamperDetailScreen(camperId: camperId),
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
        final campId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => ReportCreateScreen(campId: campId),
        );

      case registrationSuccess:
        return MaterialPageRoute(builder: (_) => RegistrationSuccessScreen());

      case registrationFailure:
        return MaterialPageRoute(builder: (_) => RegistrationFailedScreen());

      case faceRecognitionAttendance:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => FaceAttendanceScreen(
            campers: args['campers'] as List<Camper>,
            activityScheduleId: args['activityScheduleId'] as int,
            campId: args['campId'] as int,
          ),
        );
      // Ex: staff only
      // case '/staff-dashboard':
      //   if (role == "Staff") {
      //     return MaterialPageRoute(builder: (_) => StaffDashboardScreen());
      //   }
      //   return _unauthorizedRoute();

      case driverRegister:
        return MaterialPageRoute(builder: (_) => const DriverRegisterScreen());

      case driverAttendance:
        final schedule = settings.arguments as TransportSchedule;
        return MaterialPageRoute(
          builder: (_) => DriverAttendanceScreen(schedule: schedule),
        );

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
