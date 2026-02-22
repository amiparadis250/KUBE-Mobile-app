import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryBlue = Color(0xFF2872A1);
  static const Color accentCyan = Color(0xFF00AAFF);
  static const Color successGreen = Color(0xFF00CC66);
  static const Color warningOrange = Color(0xFFFFAA00);
  static const Color dangerRed = Color(0xFFFF3366);
  static const Color darkBg = Color(0xFF040810);
  static const Color cardBg = Color(0xFF0A1628);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: MaterialColor(0xFF2872A1, {
        50: Color(0xFFE8F3F9),
        100: Color(0xFFC7E2F0),
        200: Color(0xFF8FC5E1),
        300: Color(0xFF57A7D2),
        400: Color(0xFF3F8FBA),
        500: primaryBlue,
        600: Color(0xFF205B81),
        700: Color(0xFF184461),
        800: Color(0xFF102D41),
        900: Color(0xFF081621),
      }),
      scaffoldBackgroundColor: darkBg,
      cardColor: cardBg,
      appBarTheme: const AppBarTheme(
        backgroundColor: cardBg,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white70),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}