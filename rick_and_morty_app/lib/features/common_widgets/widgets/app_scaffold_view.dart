import 'package:flutter/material.dart';
import 'package:rick_and_morty_app/main/theme_notifier.dart';
import 'main_app_bar.dart';

class AppScaffoldView extends StatelessWidget {
  final String title;
  final ThemeNotifier themeNotifier;
  final List<Widget>? actions;
  final Widget body;

  const AppScaffoldView({
    super.key,
    required this.title,
    required this.themeNotifier,
    required this.body,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        title: title,
        themeNotifier: themeNotifier,
        actions: actions,
      ),
      body: SafeArea(child: body),
    );
  }
}
