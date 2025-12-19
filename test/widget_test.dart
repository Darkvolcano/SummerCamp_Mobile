import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/network/api_python_client.dart';
import 'package:summercamp/features/activity/data/repositories/activity_repository_impl.dart';
import 'package:summercamp/features/activity/data/services/activity_api_service.dart';
import 'package:summercamp/features/activity/presentation/state/activity_provider.dart';
import 'package:summercamp/features/ai_chat/data/repositories/ai_chat_repository_impl.dart';
import 'package:summercamp/features/ai_chat/data/services/ai_chat_api_service.dart';
import 'package:summercamp/features/ai_chat/domain/use_cases/get_chat_history.dart';
import 'package:summercamp/features/ai_chat/domain/use_cases/get_conversation.dart';
import 'package:summercamp/features/ai_chat/domain/use_cases/send_chat_message.dart';
import 'package:summercamp/features/ai_chat/presentation/state/ai_chat_provider.dart';
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
import 'package:summercamp/features/auth/domain/use_cases/forgot_password.dart';
import 'package:summercamp/features/auth/domain/use_cases/get_bank_user.dart';
import 'package:summercamp/features/auth/domain/use_cases/get_user_profile.dart';
import 'package:summercamp/features/auth/domain/use_cases/get_users.dart';
import 'package:summercamp/features/auth/domain/use_cases/resend_otp.dart';
import 'package:summercamp/features/auth/domain/use_cases/reset_password.dart';
import 'package:summercamp/features/auth/domain/use_cases/update_license_information.dart';
import 'package:summercamp/features/auth/domain/use_cases/update_upload_avatar.dart';
import 'package:summercamp/features/auth/domain/use_cases/update_upload_license.dart';
import 'package:summercamp/features/auth/domain/use_cases/update_user_profile.dart';
import 'package:summercamp/features/auth/domain/use_cases/upload_license.dart';
import 'package:summercamp/features/auth/domain/use_cases/verify_otp.dart';
import 'package:summercamp/features/blog/data/repositories/blog_repository_impl.dart';
import 'package:summercamp/features/blog/data/services/blog_api_service.dart';
import 'package:summercamp/features/blog/domain/use_cases/get_blogs.dart';
import 'package:summercamp/features/blog/presentation/state/blog_provider.dart';
import 'package:summercamp/features/camp/data/repositories/camp_repository_impl.dart';
import 'package:summercamp/features/camp/data/services/camp_api_service.dart';
import 'package:summercamp/features/camp/domain/use_cases/get_camp_types.dart';
import 'package:summercamp/features/camp/domain/use_cases/get_camps.dart';
import 'package:summercamp/features/camp/presentation/state/camp_provider.dart';
import 'package:summercamp/features/camper/data/repositories/camper_repository_impl.dart';
import 'package:summercamp/features/camper/data/services/camper_api_service.dart';
import 'package:summercamp/features/camper/domain/use_cases/create_camper.dart';
import 'package:summercamp/features/camper/domain/use_cases/get_camper.dart';
import 'package:summercamp/features/camper/domain/use_cases/get_camper_by_activity_id.dart';
import 'package:summercamp/features/camper/domain/use_cases/get_camper_by_core_activity_id.dart';
import 'package:summercamp/features/camper/domain/use_cases/get_camper_by_group_id.dart';
import 'package:summercamp/features/camper/domain/use_cases/get_camper_by_id.dart';
import 'package:summercamp/features/camper/domain/use_cases/get_camper_by_optional_activity_id.dart';
import 'package:summercamp/features/camper/domain/use_cases/get_camper_group.dart';
import 'package:summercamp/features/camper/domain/use_cases/get_group.dart';
import 'package:summercamp/features/camper/domain/use_cases/update_camper.dart';
import 'package:summercamp/features/camper/domain/use_cases/update_upload_avatar_camper.dart';
import 'package:summercamp/features/camper/presentation/state/camper_provider.dart';
import 'package:summercamp/features/livestream/data/repositories/livestream_repository_impl.dart';
import 'package:summercamp/features/livestream/data/services/livestream_api_service.dart';
import 'package:summercamp/features/livestream/domain/use_cases/update_livestream_room_id.dart';
import 'package:summercamp/features/livestream/presentation/state/livestream_provider.dart';
import 'package:summercamp/features/registration/data/repositories/registration_repository_impl.dart';
import 'package:summercamp/features/registration/data/services/registration_api_service.dart';
import 'package:summercamp/features/registration/domain/use_cases/cancel_registration.dart';
import 'package:summercamp/features/registration/domain/use_cases/create_register_camper_activity.dart';
import 'package:summercamp/features/registration/domain/use_cases/create_register_payment_link.dart';
import 'package:summercamp/features/activity/domain/use_cases/get_activity_schedule_by_camp_id.dart';
import 'package:summercamp/features/activity/domain/use_cases/get_activity_schedule_core_by_camp_id.dart';
import 'package:summercamp/features/activity/domain/use_cases/get_activity_schedule_optional_by_camp_id.dart';
import 'package:summercamp/features/registration/domain/use_cases/get_registraion_by_id.dart';
import 'package:summercamp/features/registration/domain/use_cases/get_registration.dart';
import 'package:summercamp/features/registration/domain/use_cases/create_register.dart';
import 'package:summercamp/features/registration/domain/use_cases/get_registration_camper.dart';
import 'package:summercamp/features/registration/presentation/state/registration_provider.dart';
import 'package:summercamp/features/report/data/repositories/report_repository_impl.dart';
import 'package:summercamp/features/report/data/services/report_api_service.dart';
import 'package:summercamp/features/report/domain/use_cases/create_report.dart';
import 'package:summercamp/features/report/domain/use_cases/get_report.dart';
import 'package:summercamp/features/report/presentation/state/report_provider.dart';
import 'package:summercamp/features/schedule/data/repositories/schedule_repository_impl.dart';
import 'package:summercamp/features/schedule/data/services/schedule_api_service.dart';
import 'package:summercamp/features/schedule/domain/use_cases/get_camper_transport_by_transport_schedule_id.dart';
import 'package:summercamp/features/schedule/domain/use_cases/get_driver_schedules.dart';
import 'package:summercamp/features/schedule/domain/use_cases/get_route_stop_by_route_id.dart';
import 'package:summercamp/features/schedule/domain/use_cases/get_staff_schedules.dart';
import 'package:summercamp/features/schedule/domain/use_cases/get_staff_transport_schedule.dart';
import 'package:summercamp/features/schedule/domain/use_cases/update_camper_transport_check_in.dart';
import 'package:summercamp/features/schedule/domain/use_cases/update_camper_transport_check_out.dart';
import 'package:summercamp/features/schedule/domain/use_cases/update_transport_schedule_end_trip.dart';
import 'package:summercamp/features/schedule/domain/use_cases/update_transport_schedule_start_trip.dart';
import 'package:summercamp/features/schedule/presentation/state/schedule_provider.dart';
import 'package:summercamp/main.dart';
import 'package:summercamp/features/auth/presentation/state/auth_provider.dart';
import 'package:summercamp/features/auth/domain/use_cases/login_user.dart';
import 'package:summercamp/features/auth/domain/use_cases/register_user.dart';
import 'package:summercamp/features/auth/data/repositories/user_repository_impl.dart';
import 'package:summercamp/features/auth/data/services/auth_api_service.dart';
import 'package:summercamp/core/network/api_client.dart';

class TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _FakeHttpClient();
  }
}

class _FakeHttpClient implements HttpClient {
  @override
  bool autoUncompress = false;

  @override
  Future<HttpClientRequest> getUrl(Uri url) async => _FakeHttpClientRequest();

  @override
  void close({bool force = false}) {}

  // Những method khác không dùng tới thì dùng noSuchMethod
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeHttpClientRequest implements HttpClientRequest {
  @override
  Future<HttpClientResponse> close() async => _FakeHttpClientResponse();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeHttpClientResponse implements HttpClientResponse {
  @override
  int get statusCode => 200;

  @override
  int get contentLength => 0;

  @override
  HttpHeaders get headers => _FakeHttpHeaders();

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int>)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    // ảnh PNG 1x1 pixel hợp lệ (base64 decode ra bytes)
    final fakePng = <int>[
      137,
      80,
      78,
      71,
      13,
      10,
      26,
      10,
      0,
      0,
      0,
      13,
      73,
      72,
      68,
      82,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      1,
      8,
      6,
      0,
      0,
      0,
      31,
      21,
      196,
      137,
      0,
      0,
      0,
      12,
      73,
      68,
      65,
      84,
      8,
      153,
      99,
      248,
      15,
      4,
      0,
      9,
      251,
      3,
      253,
      160,
      143,
      97,
      0,
      0,
      0,
      0,
      73,
      69,
      78,
      68,
      174,
      66,
      96,
      130,
    ];

    final stream = Stream<List<int>>.fromIterable([fakePng]);

    return stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError ?? false,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeHttpHeaders implements HttpHeaders {
  @override
  void noSuchMethod(Invocation invocation) {
    // headers không quan trọng với test UI, bỏ qua
  }
}

void main() {
  setUpAll(() {
    // Chặn toàn bộ network request trong test
    HttpOverrides.global = TestHttpOverrides();
  });
  testWidgets('App loads login screen', (WidgetTester tester) async {
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
    final getRegistrationCamperUseCase = GetRegistrationCamper(
      registrationRepo,
    );

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
    final updateTransportScheduleEndTripUseCase =
        UpdateTransportScheduleEndTrip(scheduleRepo);
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
    final getRouteStopByRouteIdUseCase = GetRouteStopByRouteId(scheduleRepo);

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
    final updateLivestreamRoomIdUseCase = UpdateLivestreamRoomId(
      livestreamRepo,
    );

    await tester.pumpWidget(
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
            create: (_) =>
                ReportProvider(getReportsUseCase, createReportUseCase),
          ),

          // AIChatProvider need 1 usecases (SendChatMessage)
          ChangeNotifierProvider(
            create: (_) => AIChatProvider(
              sendChatMessageUseCase: sendChatMessageUseCase,
              getChatHistoryUseCase: getChatHistoryUseCase,
              getConversationUseCase: getConversationUseCase,
            ),
          ),

          // ScheduleProvider need 9 usecases (GetStaffSchedules, UpdateTransportScheduleStartTrip, UpdateTransportScheduleEndTrip, GetDriverSchedules, GetCampersTransportByTransportScheduleId, UpdateCamperTransportAttendanceCheckInList, UpdateCamperTransportAttendanceCheckOutList, GetStaffTransportSchedule, GetRouteStopByRouteId)
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
              getRouteStopByRouteIdUseCase,
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

    await tester.pumpAndSettle();

    // Kiểm tra chỉ cần có icon Home ở màn hình
    expect(find.byIcon(Icons.home), findsOneWidget);
  });
}
