import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
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
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCharacters();
  }

  Future<void> _loadCharacters() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final provider = GetIt.instance<AbstractCharactersProvider>();
      final networkData = await provider.fetchCharacters(page: 1);

      final uiData = networkData
          .map((e) => CharacterCardModel(
                imageUrl: e.imageUrl,
                name: e.name,
                location: e.location,
                status: e.status,
                species: e.species,
              ))
          .toList();

      setState(() => _characters = uiData);
    } catch (e) {
      setState(() => _errorMessage = 'Ошибка загрузки персонажей');
      debugPrint('Ошибка: $e');
    } finally {
      setState(() => _isLoading = false);
    }
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
                : CharactersListView(characters: _characters),
      ),
    );
  }
}