import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:rick_and_morty_app/features/characters_tab/network/characters_network.dart';
import 'package:rick_and_morty_app/features/common_widgets/common_widgets.dart';
import 'package:rick_and_morty_app/features/local_storage/storage.dart';

part 'characters_event.dart';
part 'characters_state.dart';

class CharactersBloc extends Bloc<CharactersEvent, CharactersState> {
  CharactersBloc(this._provider, this._charactersBox, this._favoritesBox)
    : super(CharactersLoading()) {
    on<LoadCharacters>(_onLoad);
    on<LoadNextPage>(_onLoadNextPage);
    on<ToggleFavoriteCharacter>(_onToggleFavorite);

    _charactersSubscription = _charactersBox.watch().listen((_) {
      add(LoadCharacters());
    });

    _favoritesSubscription = _favoritesBox.watch().listen((_) {
      add(LoadCharacters());
    });
  }

  final CharactersRequestProvider _provider;
  final Box<CharacterHiveModel> _charactersBox;
  final Box<CharacterHiveModel> _favoritesBox;

  late final StreamSubscription<BoxEvent> _charactersSubscription;
  late final StreamSubscription<BoxEvent> _favoritesSubscription;

  int _currentPage = 1;
  bool _hasMore = true;
  bool _isFetching = false;

  void _onLoad(LoadCharacters event, Emitter<CharactersState> emit) {
    final cached = _charactersBox.values.map((e) => e.toCardModel()).toList();

    if (cached.isNotEmpty) {
      emit(_buildLoaded(cached));
    }

    _fetchFromNetwork();
  }

  Future<void> _fetchFromNetwork() async {
    try {
      final network = await _provider.fetchCharacters(page: _currentPage);

      final fresh = network.map((e) => e.toCardModel()).toList();

      for (final c in fresh) {
        if (!_charactersBox.values.any((e) => e.id == c.id)) {
          _charactersBox.add(CharacterHiveModel.fromCardModel(c));
        }
      }

      _hasMore = fresh.isNotEmpty;
      _currentPage++;
    } catch (_) {}
  }

  Future<void> _onLoadNextPage(
    LoadNextPage event,
    Emitter<CharactersState> emit,
  ) async {
    if (_isFetching || !_hasMore) return;
    _isFetching = true;
    await _fetchFromNetwork();
    _isFetching = false;
  }

  void _onToggleFavorite(
    ToggleFavoriteCharacter event,
    Emitter<CharactersState> emit,
  ) {
    for (final item in _favoritesBox.values) {
      if (item.id == event.character.id) {
        item.delete();
        return;
      }
    }

    _favoritesBox.add(CharacterHiveModel.fromCardModel(event.character));
  }

  CharactersLoaded _buildLoaded(List<CharacterCardModel> characters) {
    return CharactersLoaded(
      characters: characters,
      favoriteIds: _favoritesBox.values.map((e) => e.id).toSet(),
      hasMore: _hasMore,
      isPageLoading: _isFetching,
    );
  }

  @override
  Future<void> close() {
    _charactersSubscription.cancel();
    _favoritesSubscription.cancel();
    return super.close();
  }
}
