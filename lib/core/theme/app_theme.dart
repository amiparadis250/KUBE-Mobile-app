import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryBlue = Color(0xFF2872A1);
  static const Color accentCyan = Color(0xFF00AAFF);
  static const Color successGreen = Color(0xFF00CC66);
  static const Color darkBg = Color(0xFF040810);
  static const Color cardBg = Color(0xFF0A1628);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: darkBg,
      cardColor: cardBg,
      appBarTheme: const AppBarTheme(
        backgroundColor: cardBg,
        elevation: 0,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
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