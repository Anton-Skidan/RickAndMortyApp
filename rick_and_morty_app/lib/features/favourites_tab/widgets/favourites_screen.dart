import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:rick_and_morty_app/features/characters_tab/localStorage/storage.dart';
import 'package:rick_and_morty_app/features/common_widgets/common_widgets.dart';
import 'package:rick_and_morty_app/features/favourites_tab/models/favorites_sort_type.dart';

class FavoritesScreen extends StatefulWidget {
  final ThemeNotifier themeNotifier;

  const FavoritesScreen({
    super.key,
    required this.themeNotifier,
  });

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late final Box<CharacterHiveModel> _favoritesBox;
  FavoriteSortType _currentSort = FavoriteSortType.name;

  @override
  void initState() {
    super.initState();
    _favoritesBox = Hive.box<CharacterHiveModel>('favorites');
  }

  void _onSortChanged(FavoriteSortType sortType) {
    setState(() => _currentSort = sortType);
  }

  void _removeFromFavorites(CharacterCardModel character) {
    CharacterHiveModel? hiveObject;

    for (final item in _favoritesBox.values.whereType<CharacterHiveModel>()) {
      if (item.id == character.id) {
        hiveObject = item;
        break;
      }
    }

    if (hiveObject == null) return;

    hiveObject.delete();
    setState(() {});
  }

  List<CharacterCardModel> _getSortedFavorites() {
    final list = _favoritesBox.values
        .whereType<CharacterHiveModel>()
        .map((e) => e.toCardModel())
        .toList();

    switch (_currentSort) {
      case FavoriteSortType.name:
        list.sort((a, b) => a.name.compareTo(b.name));
        break;
      case FavoriteSortType.status:
        list.sort((a, b) => a.status.compareTo(b.status));
        break;
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final favorites = _getSortedFavorites();

    return Scaffold(
      appBar: MainAppBar(
        title: 'Избранное',
        themeNotifier: widget.themeNotifier,
        actions: [
          PopupMenuButton<FavoriteSortType>(
            onSelected: _onSortChanged,
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: FavoriteSortType.name,
                child: Text('Сортировать по имени'),
              ),
              PopupMenuItem(
                value: FavoriteSortType.status,
                child: Text('Сортировать по статусу'),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: CharactersListView(
          characters: favorites,
          onAction: _removeFromFavorites,
          isRemovable: true,
          emptyText: 'Нет избранных персонажей',
        ),
      ),
    );
  }
}