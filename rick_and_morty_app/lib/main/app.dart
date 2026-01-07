import 'package:flutter/material.dart';
import 'package:rick_and_morty_app/features/main_app_screen/view.dart';
import 'package:rick_and_morty_app/main/theme.dart';
import 'package:rick_and_morty_app/main/theme_notifier.dart';

class RickAndMortyTestApp extends StatelessWidget {
  RickAndMortyTestApp({super.key});

  final ThemeNotifier _themeNotifier = ThemeNotifier(ThemeMode.light);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeNotifier,
      builder: (_, mode, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: mode,
          home: MainAppScreen(themeNotifier: _themeNotifier),
        );
      },
    );
  }
}
