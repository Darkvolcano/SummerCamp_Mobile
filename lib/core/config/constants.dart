import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  // API
  static String get apiBaseUrl => dotenv.env['BE_API'] ?? '';

  // Gemini API Key
  static String get geminiApiKey => dotenv.env['GEMINI_API_KEY'] ?? '';

  // Socket
  static const String socketUrl = 'https://wdp301-su25.space/';

  // Keys store in SharedPreferences
  static const String tokenKey = 'TOKEN';
  static const String userKey = 'USER';
}
