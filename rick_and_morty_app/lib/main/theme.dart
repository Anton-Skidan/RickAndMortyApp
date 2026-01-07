import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData _baseTheme = ThemeData(
    useMaterial3: true,
    appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
    ),
    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );

  static ThemeData get lightTheme => _baseTheme.copyWith(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFFBEFEF),
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
    ),
  );

  static ThemeData get darkTheme => _baseTheme.copyWith(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF080505),
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    ),
  );
}
