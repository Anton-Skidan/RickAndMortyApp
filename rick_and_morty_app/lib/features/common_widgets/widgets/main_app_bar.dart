import 'package:flutter/material.dart';
import 'package:rick_and_morty_app/features/common_widgets/common_widgets.dart';
import 'package:rick_and_morty_app/main/theme_notifier.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final ThemeNotifier themeNotifier;
  final List<Widget>? actions;

  const MainAppBar({
    super.key,
    required this.title,
    required this.themeNotifier,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      elevation: 0,
      actions: [
        if (actions != null) ...actions!,
        ThemeToggleView(themeNotifier: themeNotifier),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
