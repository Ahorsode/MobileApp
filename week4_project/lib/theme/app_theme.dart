import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors
  static const Color slateDark = Color(0xFF1E293B);
  static const Color slateLight = Color(0xFFF1F5F9);
  static const Color slateMedium = Color(0xFF64748B);
  
  static const Color emeraldPrimary = Color(0xFF10B981);
  static const Color emeraldSecondary = Color(0xFF059669);
  
  static const Color coralAccent = Color(0xFFF43F5E);
  static const Color indigoAccent = Color(0xFF6366F1);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: indigoAccent,
        primary: indigoAccent,
        secondary: emeraldPrimary,
        tertiary: coralAccent,
        surface: Colors.white,
        background: slateLight,
      ),
      scaffoldBackgroundColor: slateLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: slateDark,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shadowColor: slateDark.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: emeraldPrimary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontWeight: FontWeight.bold,
          color: slateDark,
          letterSpacing: -0.5,
        ),
        titleLarge: TextStyle(
          fontWeight: FontWeight.bold,
          color: slateDark,
        ),
        bodyMedium: TextStyle(
          color: slateMedium,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: indigoAccent,
        primary: indigoAccent,
        secondary: emeraldPrimary,
        tertiary: coralAccent,
        surface: Color(0xFF0F172A),
        background: Color(0xFF020617),
      ),
      scaffoldBackgroundColor: Color(0xFF020617),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0F172A),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: Color(0xFF1E293B),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: emeraldPrimary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
