import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/features/activity/data/repositories/activity_repository_impl.dart';
import 'package:summercamp/features/activity/data/services/activity_api_service.dart';
import 'package:summercamp/features/activity/domain/use_cases/get_activities_by_camp.dart';
import 'package:summercamp/features/activity/presentation/state/activity_provider.dart';
import 'package:summercamp/features/auth/domain/use_cases/forgot_password.dart';
import 'package:summercamp/features/auth/domain/use_cases/get_user_profile.dart';
import 'package:summercamp/features/auth/domain/use_cases/get_users.dart';
import 'package:summercamp/features/auth/domain/use_cases/resend_otp.dart';
import 'package:summercamp/features/auth/domain/use_cases/reset_password.dart';
import 'package:summercamp/features/auth/domain/use_cases/update_user_profile.dart';
import 'package:summercamp/features/auth/domain/use_cases/verify_otp.dart';
import 'package:summercamp/features/camp/data/repositories/camp_repository_impl.dart';
import 'package:summercamp/features/camp/data/services/camp_api_service.dart';
import 'package:summercamp/features/camp/domain/use_cases/get_camp_types.dart';
import 'package:summercamp/features/camp/domain/use_cases/get_camps.dart';
import 'package:summercamp/features/camp/presentation/state/camp_provider.dart';
import 'package:summercamp/features/registration/data/repositories/registration_repository_impl.dart';
import 'package:summercamp/features/registration/data/services/registration_api_service.dart';
import 'package:summercamp/features/registration/domain/use_cases/cancel_registration.dart';
import 'package:summercamp/features/registration/domain/use_cases/create_register_camper_activity.dart';
import 'package:summercamp/features/registration/domain/use_cases/create_register_payment_link.dart';
import 'package:summercamp/features/registration/domain/use_cases/get_activity_schedule_core_by_camp_id.dart';
import 'package:summercamp/features/registration/domain/use_cases/get_activity_schedule_optional_by_camp_id.dart';
import 'package:summercamp/features/registration/domain/use_cases/get_registraion_by_id.dart';
import 'package:summercamp/features/registration/domain/use_cases/get_registration.dart';
import 'package:summercamp/features/registration/domain/use_cases/create_register.dart';
import 'package:summercamp/features/registration/presentation/state/registration_provider.dart';
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

    // Auth
    final authService = AuthApiService(apiClient);
    final userRepo = UserRepositoryImpl(authService);
    final loginUserUseCase = LoginUser(userRepo);
    final registerUserUseCase = RegisterUser(userRepo);
    final verifyOTPUseCase = VerifyOtp(userRepo);
    final getUserProfileUseCase = GetUserProfile(userRepo);
    final updateUserProfileUseCase = UpdateUserProfile(userRepo);
    final getUsersUseCase = GetUsers(userRepo);
    final resendOTPUseCase = ResendOtp(userRepo);
    final forgotPasswordUseCase = ForgotPassword(userRepo);
    final resetPasswordUseCase = ResetPassword(userRepo);

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
    final getActivitySchedulesOptionalByCampIdUseCase =
        GetActivitySchedulesOptionalByCampId(registrationRepo);
    final getActivitySchedulesCoreByCampIdUseCase =
        GetActivitySchedulesCoreByCampId(registrationRepo);

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
              userRepo,
              getUsersUseCase,
              resendOTPUseCase,
              forgotPasswordUseCase,
              resetPasswordUseCase,
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

          // RegistrationProvider need 8 usecases (GetRegistrations, RegisterCamper, CancelRegistration, GetRegistrationDetail, CreateRegisterPaymentLink, CreateRegisterOptionalCamperActivity, GetActivitySchedulesOptionalByCampId, GetActivitySchedulesCoreByCampId)
          ChangeNotifierProvider(
            create: (_) => RegistrationProvider(
              getRegistrationsUseCase,
              createRegisterUseCase,
              cancelRegistrationUseCase,
              getRegistrationByIdUseCase,
              createRegisterPaymentLinkUseCase,
              createRegisterOptionalCamperActivityUseCase,
              getActivitySchedulesOptionalByCampIdUseCase,
              getActivitySchedulesCoreByCampIdUseCase,
            ),
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
