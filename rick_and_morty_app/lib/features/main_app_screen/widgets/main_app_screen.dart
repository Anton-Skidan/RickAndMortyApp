import 'package:flutter/material.dart';
import 'package:rick_and_morty_app/features/characters_tab/view.dart';
import 'package:rick_and_morty_app/features/favorites_tab/view.dart';
import 'package:rick_and_morty_app/main/theme_notifier.dart';

class MainAppScreen extends StatefulWidget {
  final ThemeNotifier themeNotifier;

  const MainAppScreen({super.key, required this.themeNotifier});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  int _currentIndex = 0;

  List<Widget> get _screens => [
    CharactersScreen(themeNotifier: widget.themeNotifier),
    FavoritesScreen(themeNotifier: widget.themeNotifier),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Персонажи',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_border),
            activeIcon: Icon(Icons.star),
            label: 'Избранное',
          ),
        ],
      ),
    );
  }
}
