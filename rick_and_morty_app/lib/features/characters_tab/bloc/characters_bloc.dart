import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:rick_and_morty_app/features/characters_tab/network/characters_network.dart';
import 'package:rick_and_morty_app/features/common_widgets/common_widgets.dart';
import 'package:rick_and_morty_app/features/local_storage/storage.dart';

part 'characters_event.dart';
part 'characters_state.dart';

class CharactersBloc extends Bloc<CharactersEvent, CharactersState> {
  CharactersBloc(
    this._provider,
    this._charactersBox,
    this._favoritesBox,
  ) : super(CharactersInitial()) {
    on<LoadCharacters>(_onLoadCharacters);
    on<LoadNextPage>(_onLoadNextPage);
    on<ToggleFavoriteCharacter>(_onToggleFavorite);
    on<_RefreshFavorites>(_onRefreshFavorites);

    _favoritesSubscription = _favoritesBox.watch().listen((_) {
      add(_RefreshFavorites());
    });
  }

  final CharactersRequestProvider _provider;
  final Box<CharacterHiveModel> _charactersBox;
  final Box<CharacterHiveModel> _favoritesBox;

  late final StreamSubscription<BoxEvent> _favoritesSubscription;

  int _currentPage = 1;
  bool _hasMore = true;
  bool _isFetching = false;

  Future<void> _onLoadCharacters(
      LoadCharacters event, Emitter<CharactersState> emit) async {
    emit(CharactersLoading());

    final cached = _charactersBox.values
        .map((e) => e.toCardModel())
        .toList();

    if (cached.isNotEmpty) {
      emit(CharactersLoaded(
        characters: cached,
        favoriteIds: _favoritesBox.values.map((e) => e.id).toSet(),
        hasMore: true,
      ));
    }

    try {
      final network = await _provider.fetchCharacters(page: 1);

      final fresh = network
          .map((e) => CharacterCardModel(
                id: e.id,
                name: e.name,
                imageUrl: e.imageUrl,
                location: e.location,
                status: e.status,
                species: e.species,
              ))
          .toList();

      for (final c in fresh) {
        if (!_charactersBox.values.any((e) => e.id == c.id)) {
          _charactersBox.add(CharacterHiveModel.fromCardModel(c));
        }
      }

      _currentPage = 1;
      _hasMore = fresh.isNotEmpty;

      emit(CharactersLoaded(
        characters: fresh,
        favoriteIds: _favoritesBox.values.map((e) => e.id).toSet(),
        hasMore: _hasMore,
      ));
    } catch (_) {}
  }

  Future<void> _onLoadNextPage(
      LoadNextPage event, Emitter<CharactersState> emit) async {
    if (_isFetching || !_hasMore || state is! CharactersLoaded) return;

    _isFetching = true;
    final current = state as CharactersLoaded;

    emit(current.copyWith(isPageLoading: true));

    try {
      final network = await _provider.fetchCharacters(page: _currentPage + 1);

      final next = network
          .map((e) => CharacterCardModel(
                id: e.id,
                name: e.name,
                imageUrl: e.imageUrl,
                location: e.location,
                status: e.status,
                species: e.species,
              ))
          .toList();

      for (final c in next) {
        if (!_charactersBox.values.any((e) => e.id == c.id)) {
          _charactersBox.add(CharacterHiveModel.fromCardModel(c));
        }
      }

      _currentPage++;
      _hasMore = next.isNotEmpty;

      emit(current.copyWith(
        characters: [...current.characters, ...next],
        hasMore: _hasMore,
        isPageLoading: false,
      ));
    } finally {
      _isFetching = false;
    }
  }

  void _onToggleFavorite(
      ToggleFavoriteCharacter event, Emitter<CharactersState> emit) {
    CharacterHiveModel? existing;

    for (final item in _favoritesBox.values) {
      if (item.id == event.character.id) {
        existing = item;
        break;
      }
    }

    if (existing != null) {
      existing.delete();
    } else {
      _favoritesBox.add(CharacterHiveModel.fromCardModel(event.character));
    }
  }

  void _onRefreshFavorites(
      _RefreshFavorites event, Emitter<CharactersState> emit) {
    if (state is CharactersLoaded) {
      final s = state as CharactersLoaded;
      emit(s.copyWith(
        favoriteIds: _favoritesBox.values.map((e) => e.id).toSet(),
      ));
    }
  }

  @override
  Future<void> close() {
    _favoritesSubscription.cancel();
    return super.close();
  }
}