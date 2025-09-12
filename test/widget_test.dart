import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/features/auth/domain/use_cases/get_user_profiles.dart';
import 'package:summercamp/features/auth/domain/use_cases/get_users.dart';
import 'package:summercamp/features/camp/data/repositories/camp_repository_impl.dart';
import 'package:summercamp/features/camp/data/services/camp_api_service.dart';
import 'package:summercamp/features/camp/domain/use_cases/create_camp.dart';
import 'package:summercamp/features/camp/domain/use_cases/get_camps.dart';
import 'package:summercamp/features/camp/presentation/state/camp_provider.dart';
import 'package:summercamp/features/registration/data/repositories/registration_repository_impl.dart';
import 'package:summercamp/features/registration/data/services/registration_api_service.dart';
import 'package:summercamp/features/registration/domain/use_cases/cancel_registration.dart';
import 'package:summercamp/features/registration/domain/use_cases/get_registration.dart';
import 'package:summercamp/features/registration/domain/use_cases/register_camper.dart';
import 'package:summercamp/features/registration/presentation/state/registration_provider.dart';
import 'package:summercamp/main.dart';
import 'package:summercamp/features/auth/presentation/state/auth_provider.dart';
import 'package:summercamp/features/auth/domain/use_cases/login_user.dart';
import 'package:summercamp/features/auth/domain/use_cases/get_user_profile.dart';
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

    // Camp
    final campApiService = CampApiService(apiClient);
    final campRepo = CampRepositoryImpl(campApiService);
    final getCampsUseCase = GetCamps(campRepo);
    final createCampUseCase = CreateCamp(campRepo);

    // Registration
    final registrationApi = RegistrationApiService(apiClient);
    final registrationRepo = RegistrationRepositoryImpl(registrationApi);
    final getRegistrationsUseCase = GetRegistrations(registrationRepo);
    final registerCamperUseCase = RegisterCamper(registrationRepo);
    final cancelRegistrationUseCase = CancelRegistration(registrationRepo);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => AuthProvider(
              loginUser: LoginUser(userRepo),
              registerUser: RegisterUser(userRepo),
              getUserProfile: GetUserProfile(userRepo),
              getUserProfiles: GetUserProfiles(userRepo),
              getUsersUseCase: GetUsers(userRepo),
              repository: userRepo,
            ),
          ),

          // CampProvider cần 2 usecases (GetCamps, CreateCamp)
          ChangeNotifierProvider(
            create: (_) => CampProvider(getCampsUseCase, createCampUseCase),
          ),

          // RegistrationProvider cần 3 usecases (GetRegistrations, RegisterCamper, CancelRegistration)
          ChangeNotifierProvider(
            create: (_) => RegistrationProvider(
              getRegistrationsUseCase,
              registerCamperUseCase,
              cancelRegistrationUseCase,
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
