import 'package:flutter/material.dart';
import 'package:rick_and_morty_app/features/characters_tab/view.dart';
import 'package:rick_and_morty_app/features/common_widgets/main_app_bar.dart';
import 'package:rick_and_morty_app/features/favourites_tab/view.dart';

class MainAppScreen extends StatefulWidget {
  final ThemeNotifier themeNotifier;
  const MainAppScreen({super.key, required this.themeNotifier});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      CharactersScreen(themeNotifier: widget.themeNotifier),
      FavoritesScreen(themeNotifier: widget.themeNotifier),
    ];
  }

  void _onTabSelected(int index) {
    if (_currentIndex == index) return;
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabSelected,
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