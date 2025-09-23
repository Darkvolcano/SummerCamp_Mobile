import 'package:flutter/material.dart';

class StaffTheme {
  static const Color staffPrimary = Color(0xFF1565C0); // blue dark
  static const Color staffAccent = Color(0xFF42A5F5); // blue light
  static const Color staffBackground = Color(0xFFF5F9FF); // light

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    scaffoldBackgroundColor: staffBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: staffPrimary,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: staffAccent,
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
}
