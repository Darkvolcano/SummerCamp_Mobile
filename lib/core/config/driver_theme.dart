import 'package:flutter/material.dart';

class DriverTheme {
  static const Color driverPrimary = Color(0xFF388E3C); // Green 700
  static const Color driverAccent = Color(0xFF66BB6A); // Green 400
  static const Color driverBackground = Color(0xFFF1F8E9); // Green 50

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    scaffoldBackgroundColor: driverBackground,
    colorScheme: ColorScheme.fromSeed(
      seedColor: driverPrimary,
      brightness: Brightness.light,
      primary: driverPrimary,
      secondary: driverAccent,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: driverPrimary,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: driverAccent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 1,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}
