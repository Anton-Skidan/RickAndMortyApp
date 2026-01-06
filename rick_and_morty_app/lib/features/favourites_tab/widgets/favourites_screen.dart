import 'package:flutter/material.dart';
import 'package:rick_and_morty_app/features/common_widgets/common_widgets.dart';
import 'package:rick_and_morty_app/features/favourites_tab/models/favorites_sort_type.dart';

class FavoritesScreen extends StatefulWidget {
  final ThemeNotifier themeNotifier;

  const FavoritesScreen({super.key, required this.themeNotifier});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  FavoriteSortType _currentSort = FavoriteSortType.name;

  late List<CharacterCardModel> _favorites;

  @override
  void initState() {
    super.initState();
    _favorites = List.of(_mockFavorites);
    _sortFavorites();
  }

  void _sortFavorites() {
    switch (_currentSort) {
      case FavoriteSortType.name:
        _favorites.sort((a, b) => a.name.compareTo(b.name));
        break;
      case FavoriteSortType.status:
        _favorites.sort((a, b) => a.status.compareTo(b.status));
        break;
    }
  }

  void _onSortChanged(FavoriteSortType sortType) {
    setState(() {
      _currentSort = sortType;
      _sortFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
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
          characters: _favorites,
          emptyText: 'Нет избранных персонажей',
        ),
      ),
    );
  }
}

final List<CharacterCardModel> _mockFavorites = [
  CharacterCardModel(
    imageUrl: 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
    name: 'Rick Sanchez',
    location: 'Earth',
    status: 'Alive',
    species: 'Human',
  ),
  CharacterCardModel(
    imageUrl: 'https://rickandmortyapi.com/api/character/avatar/5.jpeg',
    name: 'Jerry Smith',
    location: 'Earth',
    status: 'Alive',
    species: 'Human',
  ),
  CharacterCardModel(
    imageUrl: 'https://rickandmortyapi.com/api/character/avatar/8.jpeg',
    name: 'Adjudicator Rick',
    location: 'Citadel of Ricks',
    status: 'Dead',
    species: 'Human',
  ),
];
