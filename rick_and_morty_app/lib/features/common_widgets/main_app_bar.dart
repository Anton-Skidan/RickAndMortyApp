import 'package:flutter/material.dart';

class ThemeNotifier extends ValueNotifier<ThemeMode> {
  ThemeNotifier(super.mode);

  void toggle() {
    value = value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}

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
        ValueListenableBuilder<ThemeMode>(
          valueListenable: themeNotifier,
          builder: (context, mode, _) {
            return IconButton(
              icon: Icon(
                mode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode,
              ),
              onPressed: () => themeNotifier.toggle(),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
