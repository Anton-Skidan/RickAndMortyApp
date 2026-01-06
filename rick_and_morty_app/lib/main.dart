import 'package:flutter/material.dart';
import 'package:rick_and_morty_app/features/main_app_screen/view.dart';
import 'package:rick_and_morty_app/theme.dart';
import 'features/common_widgets/common_widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final ThemeNotifier themeNotifier;

  @override
  void initState() {
    super.initState();
    themeNotifier = ThemeNotifier(ThemeMode.light);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: mode,
          home: MainAppScreen(themeNotifier: themeNotifier),
        );
      },
    );
  }
}