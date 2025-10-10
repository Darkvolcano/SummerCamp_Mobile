import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/features/auth/domain/use_cases/resend_otp.dart';
import 'package:summercamp/features/auth/domain/use_cases/verify_otp.dart';
import 'package:summercamp/features/blog/data/repositories/blog_repository_impl.dart';
import 'package:summercamp/features/blog/data/services/blog_api_service.dart';
import 'package:summercamp/features/blog/domain/use_cases/get_blogs.dart';
import 'package:summercamp/features/blog/presentation/state/blog_provider.dart';
import 'package:summercamp/features/camper/data/repositories/camper_repository_impl.dart';
import 'package:summercamp/features/camper/data/services/camper_api_service.dart';
import 'package:summercamp/features/camper/domain/use_cases/create_camper.dart';
import 'package:summercamp/features/camper/domain/use_cases/get_camper.dart';
import 'package:summercamp/features/camper/domain/use_cases/update_camper.dart';
import 'package:summercamp/features/camper/presentation/state/camper_provider.dart';
import 'package:summercamp/features/report/data/repositories/report_repository_impl.dart';
import 'package:summercamp/features/report/data/services/report_api_service.dart';
import 'package:summercamp/features/report/domain/use_cases/create_report.dart';
import 'package:summercamp/features/report/domain/use_cases/get_report.dart';
import 'package:summercamp/features/report/presentation/state/report_provider.dart';

import 'core/config/app_routes.dart';
import 'core/config/app_theme.dart';
import 'core/network/api_client.dart';

import 'features/auth/presentation/state/auth_provider.dart';
import 'features/auth/data/services/auth_api_service.dart';
import 'features/auth/data/repositories/user_repository_impl.dart';
import 'features/auth/domain/use_cases/login_user.dart';
import 'features/auth/domain/use_cases/register_user.dart';
import 'features/auth/domain/use_cases/get_user_profile.dart';
import 'features/auth/domain/use_cases/get_user_profiles.dart';
import 'features/auth/domain/use_cases/get_users.dart';

import 'features/camp/data/services/camp_api_service.dart';
import 'features/camp/data/repositories/camp_repository_impl.dart';
import 'features/camp/domain/use_cases/get_camps.dart';
import 'features/camp/domain/use_cases/create_camp.dart';
import 'features/camp/presentation/state/camp_provider.dart';

import 'features/registration/data/services/registration_api_service.dart';
import 'features/registration/data/repositories/registration_repository_impl.dart';
import 'features/registration/domain/use_cases/get_registration.dart';
import 'features/registration/domain/use_cases/create_register.dart';
import 'features/registration/domain/use_cases/cancel_registration.dart';
import 'features/registration/presentation/state/registration_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('vi_VN');
  final apiClient = ApiClient();

  // Auth
  final authService = AuthApiService(apiClient);
  final userRepo = UserRepositoryImpl(authService);

  // Camp
  final campApiService = CampApiService(apiClient);
  final campRepo = CampRepositoryImpl(campApiService);
  final getCampsUseCase = GetCamps(campRepo);
  final createCampUseCase = CreateCamp(campRepo);

  // Registration
  final registrationApi = RegistrationApiService(apiClient);
  final registrationRepo = RegistrationRepositoryImpl(registrationApi);
  final getRegistrationsUseCase = GetRegistrations(registrationRepo);
  final createRegisterUseCase = CreateRegister(registrationRepo);
  final cancelRegistrationUseCase = CancelRegistration(registrationRepo);

  // Blog
  final blogApi = BlogApiService(apiClient);
  final blogRepo = BlogRepositoryImpl(blogApi);
  final getBlogsUseCase = GetBlogs(blogRepo);

  // Camper
  final camperApi = CamperApiService(apiClient);
  final camperRepo = CamperRepositoryImpl(camperApi);
  final getCampersUseCase = GetCampers(camperRepo);
  final createCamperUseCase = CreateCamper(camperRepo);
  final updateCamperUseCase = UpdateCamper(camperRepo);

  // Report
  final reportApi = ReportApiService(apiClient);
  final reportRepo = ReportRepositoryImpl(reportApi);
  final getReportsUseCase = GetReports(reportRepo);
  final createReportUseCase = CreateReport(reportRepo);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            loginUser: LoginUser(userRepo),
            registerUser: RegisterUser(userRepo),
            verifyOTP: VerifyOtp(userRepo),
            getUserProfile: GetUserProfile(userRepo),
            getUserProfiles: GetUserProfiles(userRepo),
            getUsersUseCase: GetUsers(userRepo),
            resendOTP: ResendOtp(userRepo),
            repository: userRepo,
          ),
        ),

        // CampProvider need 2 usecases (GetCamps, CreateCamp)
        ChangeNotifierProvider(
          create: (_) => CampProvider(getCampsUseCase, createCampUseCase),
        ),

        // RegistrationProvider need 3 usecases (GetRegistrations, RegisterCamper, CancelRegistration)
        ChangeNotifierProvider(
          create: (_) => RegistrationProvider(
            getRegistrationsUseCase,
            createRegisterUseCase,
            cancelRegistrationUseCase,
          ),
        ),

        // BlogProvider need 1 usecases (GetBlogs)
        ChangeNotifierProvider(create: (_) => BlogProvider(getBlogsUseCase)),

        // CamperProvider need 3 usecases (GetRegistrations, RegisterCamper, CancelRegistration)
        ChangeNotifierProvider(
          create: (_) => CamperProvider(
            createCamperUseCase,
            getCampersUseCase,
            updateCamperUseCase,
          ),
        ),

        // ReportProvider need 2 usecases (GetReports, CreateReport)
        ChangeNotifierProvider(
          create: (_) => ReportProvider(getReportsUseCase, createReportUseCase),
        ),
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

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', 'US'), Locale('vi', 'VN')],
    );
  }
}
