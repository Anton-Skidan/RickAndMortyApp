import 'package:flutter/material.dart';

class ThemeNotifier extends ValueNotifier<ThemeMode> {
  ThemeNotifier(super.value);

  void toggleThemeMode() {
    value = value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}
