import 'package:flutter/material.dart';

class AppTheme {
  // Màu chủ đạo mùa hè
  static const Color summerPrimary = Color(0xFFFFA726); // cam nắng
  static const Color summerAccent = Color(0xFFFF7043); // cam đậm
  static const Color summerBackground = Color(0xFFFFF8E7); // vàng nhạt nền
  static const Color summerBlue = Color(0xFF4FC3F7); // xanh biển nhạt

  // Màu sáng (Summer Day)
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    colorScheme:
        ColorScheme.fromSeed(
          seedColor: summerPrimary,
          brightness: Brightness.light,
        ).copyWith(
          primary: summerPrimary,
          secondary: summerBlue,
          surface: Colors.white,
          onSurface: Colors.black87,
          error: Colors.redAccent,
          onError: Colors.white,
        ),
    scaffoldBackgroundColor: summerBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: summerPrimary,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: summerAccent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );

  // Màu tối (Summer Night)
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    colorScheme:
        ColorScheme.fromSeed(
          seedColor: summerAccent,
          brightness: Brightness.dark,
        ).copyWith(
          primary: summerAccent,
          secondary: summerBlue,
          surface: const Color(0xFF222244),
          onSurface: Colors.white70,
          error: Colors.redAccent,
          onError: Colors.white,
        ),
    scaffoldBackgroundColor: const Color(0xFF1B1B2F), // tím than đêm
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF2C2C54),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2C2C54),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: summerAccent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF2C2C54),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}
