import 'package:rick_and_morty_app/main/theme_notifier.dart';
import 'package:flutter/material.dart';

class ThemeToggleView extends StatelessWidget {
  final ThemeNotifier themeNotifier;

  const ThemeToggleView({super.key, required this.themeNotifier});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, mode, __) {
        return IconButton(
          icon: Icon(
            mode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode,
          ),
          onPressed: themeNotifier.toggleThemeMode,
        );
      },
    );
  }
}
