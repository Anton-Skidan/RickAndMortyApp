import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:rick_and_morty_app/features/local_storage/storage.dart';
import 'package:rick_and_morty_app/features/characters_tab/network/characters_network.dart';
import 'package:rick_and_morty_app/features/common_widgets/common_widgets.dart';

class CharactersScreen extends StatefulWidget {
  final ThemeNotifier themeNotifier;

  const CharactersScreen({super.key, required this.themeNotifier});

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  List<CharacterCardModel> _characters = [];
  late final Box<CharacterHiveModel> _favoritesBox;

  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _favoritesBox = Hive.box<CharacterHiveModel>('favorites');
    _loadCharacters();
  }

  Future<void> _loadCharacters() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final charactersBox = Hive.box<CharacterHiveModel>('characters');

    try {
      final cached = charactersBox.values
          .whereType<CharacterHiveModel>()
          .map((e) => e.toCardModel())
          .toList();

      if (cached.isNotEmpty) {
        setState(() => _characters = cached);
      }

      final provider = GetIt.instance<CharactersRequestProvider>();
      final networkData = await provider.fetchCharacters(page: 1);

      final uiData = networkData
          .map(
            (e) => CharacterCardModel(
              id: e.id,
              name: e.name,
              imageUrl: e.imageUrl,
              location: e.location,
              status: e.status,
              species: e.species,
            ),
          )
          .toList();

      for (final c in uiData) {
        if (!charactersBox.values.any((e) => e.id == c.id)) {
          charactersBox.add(CharacterHiveModel.fromCardModel(c));
        }
      }

      if (!mounted) return;

      for (final c in uiData) {
        precacheImage(CachedNetworkImageProvider(c.imageUrl), context);
      }

      setState(() => _characters = uiData);
    } catch (e) {
      if (_characters.isEmpty) {
        setState(() => _errorMessage = 'Ошибка загрузки персонажей');
      }
      debugPrint('Ошибка загрузки персонажей: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _toggleFavorite(CharacterCardModel character) {
    CharacterHiveModel? existing;

    for (final item in _favoritesBox.values.whereType<CharacterHiveModel>()) {
      if (item.id == character.id) {
        existing = item;
        break;
      }
    }

    if (existing != null) {
      existing.delete();
    } else {
      _favoritesBox.add(CharacterHiveModel.fromCardModel(character));
    }

    setState(() {});
  }

  Set<CharacterCardModel> _favoriteCards() {
    return _favoritesBox.values
        .whereType<CharacterHiveModel>()
        .map((e) => e.toCardModel())
        .toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        title: 'Персонажи',
        themeNotifier: widget.themeNotifier,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
            ? Center(child: Text(_errorMessage!))
            : CharactersListView(
                characters: _characters,
                favorites: _favoriteCards(),
                onAction: _toggleFavorite,
              ),
      ),
    );
  }
}
