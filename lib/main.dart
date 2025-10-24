import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

import 'package:summercamp/features/activity/data/repositories/activity_repository_impl.dart';
import 'package:summercamp/features/activity/data/services/activity_api_service.dart';
import 'package:summercamp/features/activity/domain/use_cases/get_activities_by_camp.dart';
import 'package:summercamp/features/activity/presentation/state/activity_provider.dart';
import 'package:summercamp/features/auth/domain/use_cases/forgot_password.dart';
import 'package:summercamp/features/auth/domain/use_cases/resend_otp.dart';
import 'package:summercamp/features/auth/domain/use_cases/reset_password.dart';
import 'package:summercamp/features/auth/domain/use_cases/verify_otp.dart';
import 'package:summercamp/features/blog/data/repositories/blog_repository_impl.dart';
import 'package:summercamp/features/blog/data/services/blog_api_service.dart';
import 'package:summercamp/features/blog/domain/use_cases/get_blogs.dart';
import 'package:summercamp/features/blog/presentation/state/blog_provider.dart';
import 'package:summercamp/features/camp/domain/use_cases/get_camp_types.dart';
import 'package:summercamp/features/camper/data/repositories/camper_repository_impl.dart';
import 'package:summercamp/features/camper/data/services/camper_api_service.dart';
import 'package:summercamp/features/camper/domain/use_cases/create_camper.dart';
import 'package:summercamp/features/camper/domain/use_cases/get_camper.dart';
import 'package:summercamp/features/camper/domain/use_cases/get_camper_by_id.dart';
import 'package:summercamp/features/camper/domain/use_cases/get_camper_group.dart';
import 'package:summercamp/features/camper/domain/use_cases/update_camper.dart';
import 'package:summercamp/features/camper/presentation/state/camper_provider.dart';
import 'package:summercamp/features/registration/domain/use_cases/create_register_camper_activity.dart';
import 'package:summercamp/features/registration/domain/use_cases/create_register_payment_link.dart';
import 'package:summercamp/features/registration/domain/use_cases/get_registraion_by_id.dart';
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
  final getCampTypesUseCase = GetCampTypes(campRepo);

  // Activity
  final activityApiService = ActivityApiService(apiClient);
  final activityRepo = ActivityRepositoryImpl(activityApiService);
  final getActivitiesUseCase = GetActivitiesByCampId(activityRepo);

  // Registration
  final registrationApi = RegistrationApiService(apiClient);
  final registrationRepo = RegistrationRepositoryImpl(registrationApi);
  final getRegistrationsUseCase = GetRegistrations(registrationRepo);
  final createRegisterUseCase = CreateRegister(registrationRepo);
  final cancelRegistrationUseCase = CancelRegistration(registrationRepo);
  final getRegistrationByIdUseCase = GetRegistrationById(registrationRepo);
  final createRegisterPaymentLinkUseCase = CreateRegisterPaymentLink(
    registrationRepo,
  );
  final createRegisterOptionalCamperActivityUseCase =
      CreateRegisterOptionalCamperActivity(registrationRepo);

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
  final getCamperByIdUseCase = GetCamperById(camperRepo);
  final getCamperGroupsUseCase = GetCamperGroups(camperRepo);

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
            forgotPassword: ForgotPassword(userRepo),
            resetPassword: ResetPassword(userRepo),
            repository: userRepo,
          ),
        ),

        // CampProvider need 2 usecases (GetCamps, GetCampTypes)
        ChangeNotifierProvider(
          create: (_) => CampProvider(getCampsUseCase, getCampTypesUseCase),
        ),

        // ActivityProvider need 1 usecases (GetActivitiess)
        ChangeNotifierProvider(
          create: (_) => ActivityProvider(getActivitiesUseCase),
        ),

        // RegistrationProvider need 6 usecases (GetRegistrations, RegisterCamper, CancelRegistration, GetRegistrationDetail, CreateRegisterPaymentLink, CreateRegisterOptionalCamperActivity)
        ChangeNotifierProvider(
          create: (_) => RegistrationProvider(
            getRegistrationsUseCase,
            createRegisterUseCase,
            cancelRegistrationUseCase,
            getRegistrationByIdUseCase,
            createRegisterPaymentLinkUseCase,
            createRegisterOptionalCamperActivityUseCase,
          ),
        ),

        // BlogProvider need 1 usecases (GetBlogs)
        ChangeNotifierProvider(create: (_) => BlogProvider(getBlogsUseCase)),

        // CamperProvider need 5 usecases (GetCampers, CreateCamper, UpdateCamper, getCamperById, getCamperGroups)
        ChangeNotifierProvider(
          create: (_) => CamperProvider(
            createCamperUseCase,
            getCampersUseCase,
            updateCamperUseCase,
            getCamperByIdUseCase,
            getCamperGroupsUseCase,
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

// class SummerCampApp extends StatelessWidget {
//   const SummerCampApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Summer Camp',
//       theme: AppTheme.lightTheme,
//       darkTheme: AppTheme.darkTheme,
//       debugShowCheckedModeBanner: false,
//       initialRoute: AppRoutes.login,
//       onGenerateRoute: AppRoutes.generateRoute,

//       localizationsDelegates: const [
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//       ],
//       supportedLocales: const [Locale('en', 'US'), Locale('vi', 'VN')],
//     );
//   }
// }
class SummerCampApp extends StatefulWidget {
  const SummerCampApp({super.key});

  @override
  State<SummerCampApp> createState() => _SummerCampAppState();
}

class _SummerCampAppState extends State<SummerCampApp> {
  bool _isOffline = false;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _checkInitialConnection();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  Future<void> _checkInitialConnection() async {
    final List<ConnectivityResult> results = await Connectivity()
        .checkConnectivity();
    _updateConnectionStatus(results);
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    final bool isOnline = results.any(
      (result) => result != ConnectivityResult.none,
    );

    final newStatus = !isOnline;

    if (newStatus != _isOffline && mounted) {
      setState(() {
        _isOffline = newStatus;
      });
    }
  }

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

      builder: (context, child) {
        return Stack(
          children: [child!, if (_isOffline) const _OfflineDialog()],
        );
      },
    );
  }
}

class _OfflineDialog extends StatelessWidget {
  const _OfflineDialog();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.black.withValues(alpha: 0.7),
        body: Center(
          child: Card(
            margin: const EdgeInsets.all(24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(color: AppTheme.summerAccent),
                  const SizedBox(height: 24),
                  Text(
                    "Lỗi kết nối mạng",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Vui lòng kết nối mạng để sử dụng app.",
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(fontFamily: "Quicksand"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
