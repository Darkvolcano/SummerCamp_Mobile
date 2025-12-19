import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:summercamp/core/network/api_python_client.dart';
import 'package:summercamp/features/activity/domain/use_cases/get_activity_schedule_by_camp_id.dart';
import 'package:summercamp/features/attendance/data/repositories/attendance_repository_impl.dart';
import 'package:summercamp/features/attendance/data/services/attendance_api_service.dart';
import 'package:summercamp/features/attendance/domain/use_cases/preload_face_database.dart';
import 'package:summercamp/features/attendance/domain/use_cases/recognize_face.dart';
import 'package:summercamp/features/attendance/domain/use_cases/recognize_group.dart';
import 'package:summercamp/features/attendance/domain/use_cases/update_attendance.dart';
import 'package:summercamp/features/attendance/presentation/state/attendance_provider.dart';
import 'package:summercamp/features/auth/domain/use_cases/change_password.dart';
import 'package:summercamp/features/auth/domain/use_cases/create_bank_user.dart';
import 'package:summercamp/features/auth/domain/use_cases/driver_register.dart';
import 'package:summercamp/features/auth/domain/use_cases/get_bank_user.dart';
import 'package:summercamp/features/auth/domain/use_cases/update_license_information.dart';
import 'package:summercamp/features/auth/domain/use_cases/update_upload_avatar.dart';
import 'package:summercamp/features/auth/domain/use_cases/update_upload_license.dart';
import 'package:summercamp/features/auth/domain/use_cases/upload_license.dart';
import 'package:summercamp/features/camper/domain/use_cases/get_camper_by_activity_id.dart';
import 'package:summercamp/features/camper/domain/use_cases/get_camper_by_core_activity_id.dart';
import 'package:summercamp/features/camper/domain/use_cases/get_camper_by_group_id.dart';
import 'package:summercamp/features/camper/domain/use_cases/get_camper_by_optional_activity_id.dart';
import 'package:summercamp/features/camper/domain/use_cases/get_group.dart';
import 'package:summercamp/features/camper/domain/use_cases/update_upload_avatar_camper.dart';
import 'package:summercamp/features/livestream/data/repositories/livestream_repository_impl.dart';
import 'package:summercamp/features/livestream/data/services/livestream_api_service.dart';
import 'package:summercamp/features/livestream/domain/use_cases/update_livestream_room_id.dart';
import 'package:summercamp/features/livestream/presentation/state/livestream_provider.dart';
import 'package:summercamp/features/registration/domain/use_cases/get_registration_camper.dart';
import 'package:summercamp/features/schedule/domain/use_cases/get_camper_transport_by_transport_schedule_id.dart';
import 'package:summercamp/features/schedule/domain/use_cases/get_driver_schedules.dart';
import 'package:summercamp/features/schedule/domain/use_cases/get_staff_transport_schedule.dart';
import 'package:summercamp/features/schedule/domain/use_cases/update_camper_transport_check_in.dart';
import 'package:summercamp/features/schedule/domain/use_cases/update_camper_transport_check_out.dart';
import 'package:summercamp/features/schedule/domain/use_cases/update_transport_schedule_end_trip.dart';
import 'package:summercamp/features/schedule/domain/use_cases/update_transport_schedule_start_trip.dart';
import 'dart:async';

import 'package:summercamp/features/ai_chat/data/repositories/ai_chat_repository_impl.dart';
import 'package:summercamp/features/ai_chat/data/services/ai_chat_api_service.dart';
import 'package:summercamp/features/ai_chat/domain/use_cases/get_chat_history.dart';
import 'package:summercamp/features/ai_chat/domain/use_cases/get_conversation.dart';
import 'package:summercamp/features/ai_chat/domain/use_cases/send_chat_message.dart';
import 'package:summercamp/features/ai_chat/presentation/state/ai_chat_provider.dart';
import 'package:summercamp/features/schedule/data/repositories/schedule_repository_impl.dart';
import 'package:summercamp/features/schedule/data/services/schedule_api_service.dart';
import 'package:summercamp/features/schedule/domain/use_cases/get_staff_schedules.dart';
import 'package:summercamp/features/schedule/presentation/state/schedule_provider.dart';

import 'package:summercamp/features/activity/data/repositories/activity_repository_impl.dart';
import 'package:summercamp/features/activity/data/services/activity_api_service.dart';
import 'package:summercamp/features/activity/presentation/state/activity_provider.dart';
import 'package:summercamp/features/auth/domain/use_cases/forgot_password.dart';
import 'package:summercamp/features/auth/domain/use_cases/resend_otp.dart';
import 'package:summercamp/features/auth/domain/use_cases/reset_password.dart';
import 'package:summercamp/features/auth/domain/use_cases/verify_otp.dart';
import 'package:summercamp/features/auth/domain/use_cases/update_user_profile.dart';
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
import 'package:summercamp/features/activity/domain/use_cases/get_activity_schedule_core_by_camp_id.dart';
import 'package:summercamp/features/activity/domain/use_cases/get_activity_schedule_optional_by_camp_id.dart';
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

  await dotenv.load(fileName: ".env");

  await initializeDateFormatting('vi_VN');
  final apiClient = ApiClient();
  final apiPythonClient = ApiPythonClient();

  // Auth
  final authService = AuthApiService(apiClient);
  final userRepo = UserRepositoryImpl(authService);
  final loginUserUseCase = LoginUser(userRepo);
  final registerUserUseCase = RegisterUser(userRepo);
  final verifyOTPUseCase = VerifyOtp(userRepo);
  final getUserProfileUseCase = GetUserProfile(userRepo);
  final updateUserProfileUseCase = UpdateUserProfile(userRepo);
  final updateUploadAvatarUseCase = UpdateUploadAvatar(userRepo);
  final getUsersUseCase = GetUsers(userRepo);
  final resendOTPUseCase = ResendOtp(userRepo);
  final forgotPasswordUseCase = ForgotPassword(userRepo);
  final resetPasswordUseCase = ResetPassword(userRepo);
  final driverRegisterUseCase = DriverRegister(userRepo);
  final uploadLicenseUseCase = UploadLicense(userRepo);
  final changePasswordUseCase = ChangePassword(userRepo);
  final getBankUserUseCase = GetBankUsers(userRepo);
  final createBankUserUseCase = CreateBankUser(userRepo);
  final updateUploadLicenseUseCase = UpdateUploadLicense(userRepo);
  final updateLicenseInformation = UpdateLicenseInformation(userRepo);

  // Camp
  final campApiService = CampApiService(apiClient);
  final campRepo = CampRepositoryImpl(campApiService);
  final getCampsUseCase = GetCamps(campRepo);
  final getCampTypesUseCase = GetCampTypes(campRepo);

  // Activity
  final activityApiService = ActivityApiService(apiClient);
  final activityRepo = ActivityRepositoryImpl(activityApiService);
  final getActivitySchedulesByCampIdUseCase = GetActivitySchedulesByCampId(
    activityRepo,
  );
  final getActivitySchedulesOptionalByCampIdUseCase =
      GetActivitySchedulesOptionalByCampId(activityRepo);
  final getActivitySchedulesCoreByCampIdUseCase =
      GetActivitySchedulesCoreByCampId(activityRepo);

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
  final getRegistrationCamperUseCase = GetRegistrationCamper(registrationRepo);

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
  final getCamperGroupByGroupIdUseCase = GetCamperGroupByGroupId(camperRepo);
  final getCampersByCoreActivityUseCase = GetCampersByCoreActivityId(
    camperRepo,
  );
  final getCampersByOptionalActivityUseCase = GetCampersByOptionalActivityId(
    camperRepo,
  );
  final getCampersByActivityUseCase = GetCampersByActivityId(camperRepo);
  final getCampGroupUseCase = GetCampGroup(camperRepo);
  final updateUploadAvatarCamper = UpdateUploadAvatarCamper(camperRepo);

  // Report
  final reportApi = ReportApiService(apiClient);
  final reportRepo = ReportRepositoryImpl(reportApi);
  final getReportsUseCase = GetReports(reportRepo);
  final createReportUseCase = CreateReport(reportRepo);

  // AI Chat
  final aiChatApi = AIChatApiService(apiClient);
  final aiChatRepo = AIChatRepositoryImpl(aiChatApi);
  final sendChatMessageUseCase = SendChatMessage(aiChatRepo);
  final getChatHistoryUseCase = GetChatHistory(aiChatRepo);
  final getConversationUseCase = GetConversation(aiChatRepo);

  // Schedule
  final scheduleApi = ScheduleApiService(apiClient);
  final scheduleRepo = ScheduleRepositoryImpl(scheduleApi);
  final getStaffSchedulesUseCase = GetStaffSchedules(scheduleRepo);
  final updateTransportScheduleStartTripUseCase =
      UpdateTransportScheduleStartTrip(scheduleRepo);
  final updateTransportScheduleEndTripUseCase = UpdateTransportScheduleEndTrip(
    scheduleRepo,
  );
  final getDriverSchedulesUseCase = GetDriverSchedules(scheduleRepo);
  final getCampersTransportByTransportScheduleIdUseCase =
      GetCampersTransportByTransportScheduleId(scheduleRepo);
  final updateCamperTransportAttendanceCheckInListUseCase =
      UpdateCamperTransportAttendanceListCheckIn(scheduleRepo);
  final updateCamperTransportAttendanceCheckOutListUseCase =
      UpdateCamperTransportAttendanceListCheckOut(scheduleRepo);
  final getStaffTransportSchedulesUseCase = GetStaffTransportSchedule(
    scheduleRepo,
  );

  // Attendance
  final attendanceApi = AttendanceApiService(apiClient, apiPythonClient);
  final attendanceRepo = AttendanceRepositoryImpl(attendanceApi);
  final updateAttendanceUseCase = UpdateAttendanceList(attendanceRepo);
  final recognizeFaceUseCase = RecognizeFace(attendanceRepo);
  final preloadFaceDatabaseUseCase = PreloadFaceDatabase(attendanceRepo);
  final recognizeGroup = RecognizeGroup(attendanceRepo);

  // Livestream
  final livestreamApi = LivestreamApiService(apiClient);
  final livestreamRepo = LivestreamRepositoryImpl(livestreamApi);
  final updateLivestreamRoomIdUseCase = UpdateLivestreamRoomId(livestreamRepo);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            loginUserUseCase,
            registerUserUseCase,
            verifyOTPUseCase,
            getUserProfileUseCase,
            updateUserProfileUseCase,
            updateUploadAvatarUseCase,
            userRepo,
            getUsersUseCase,
            resendOTPUseCase,
            forgotPasswordUseCase,
            resetPasswordUseCase,
            driverRegisterUseCase,
            uploadLicenseUseCase,
            changePasswordUseCase,
            getBankUserUseCase,
            createBankUserUseCase,
            updateUploadLicenseUseCase,
            updateLicenseInformation,
          ),
        ),

        // CampProvider need 2 usecases (GetCamps, GetCampTypes)
        ChangeNotifierProvider(
          create: (_) => CampProvider(getCampsUseCase, getCampTypesUseCase),
        ),

        // ActivityProvider need 1 usecases (GetActivitySchedulesOptionalByCampId, GetActivitySchedulesCoreByCampId, GetActivitySchedulesByCampId)
        ChangeNotifierProvider(
          create: (_) => ActivityProvider(
            getActivitySchedulesOptionalByCampIdUseCase,
            getActivitySchedulesCoreByCampIdUseCase,
            getActivitySchedulesByCampIdUseCase,
          ),
        ),

        // RegistrationProvider need 7 usecases (GetRegistrations, RegisterCamper, CancelRegistration, GetRegistrationDetail, CreateRegisterPaymentLink, CreateRegisterOptionalCamperActivity, GetRegistrationCamper)
        ChangeNotifierProvider(
          create: (_) => RegistrationProvider(
            getRegistrationsUseCase,
            createRegisterUseCase,
            cancelRegistrationUseCase,
            getRegistrationByIdUseCase,
            createRegisterPaymentLinkUseCase,
            createRegisterOptionalCamperActivityUseCase,
            getRegistrationCamperUseCase,
          ),
        ),

        // BlogProvider need 1 usecases (GetBlogs)
        ChangeNotifierProvider(create: (_) => BlogProvider(getBlogsUseCase)),

        // CamperProvider need 11 usecases (GetCampers, CreateCamper, UpdateCamper, getCamperById, getCamperGroups, getCamperGroupByGroupId, getCampersByCoreActivityId, getCampersByOptionalActivityId, getCampersByActivityId, getCampGroup, updateUploadAvatarCamper)
        ChangeNotifierProvider(
          create: (_) => CamperProvider(
            createCamperUseCase,
            getCampersUseCase,
            updateCamperUseCase,
            getCamperByIdUseCase,
            getCamperGroupsUseCase,
            getCamperGroupByGroupIdUseCase,
            getCampersByCoreActivityUseCase,
            getCampersByOptionalActivityUseCase,
            getCampersByActivityUseCase,
            getCampGroupUseCase,
            updateUploadAvatarCamper,
          ),
        ),

        // ReportProvider need 2 usecases (GetReports, CreateReport)
        ChangeNotifierProvider(
          create: (_) => ReportProvider(getReportsUseCase, createReportUseCase),
        ),

        // AIChatProvider need 3 usecases (SendChatMessage, GetChatHistory, GetConversation)
        ChangeNotifierProvider(
          create: (_) => AIChatProvider(
            sendChatMessageUseCase: sendChatMessageUseCase,
            getChatHistoryUseCase: getChatHistoryUseCase,
            getConversationUseCase: getConversationUseCase,
          ),
        ),

        // ScheduleProvider need 8 usecases (GetStaffSchedules, UpdateTransportScheduleStartTrip, UpdateTransportScheduleEndTrip, GetDriverSchedules, GetCampersTransportByTransportScheduleId, UpdateCamperTransportAttendanceCheckInList, UpdateCamperTransportAttendanceCheckOutList, GetStaffTransportSchedule)
        ChangeNotifierProvider(
          create: (_) => ScheduleProvider(
            getStaffSchedulesUseCase,
            updateTransportScheduleStartTripUseCase,
            updateTransportScheduleEndTripUseCase,
            getDriverSchedulesUseCase,
            getCampersTransportByTransportScheduleIdUseCase,
            updateCamperTransportAttendanceCheckInListUseCase,
            updateCamperTransportAttendanceCheckOutListUseCase,
            getStaffTransportSchedulesUseCase,
          ),
        ),

        // AttendanceProvider need 4 usecases (UpdateAttendanceList, RecognizeFace, PreloadFaceDatabase, RecognizeGroup)
        ChangeNotifierProvider(
          create: (_) => AttendanceProvider(
            updateAttendanceUseCase,
            recognizeFaceUseCase,
            preloadFaceDatabaseUseCase,
            recognizeGroup,
          ),
        ),

        // LivestreamProvider need 1 usecases (UpdateLivestreamRoomId)
        ChangeNotifierProvider(
          create: (_) => LivestreamProvider(updateLivestreamRoomIdUseCase),
        ),
      ],
      child: const SummerCampApp(),
    ),
  );
}

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
      initialRoute: AppRoutes.home,
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
