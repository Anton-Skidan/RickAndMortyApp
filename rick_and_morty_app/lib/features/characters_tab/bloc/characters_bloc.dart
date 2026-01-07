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

  Future<void> _onLoadCharacters(
      LoadCharacters event, Emitter<CharactersState> emit) async {
    emit(CharactersLoading());

    try {
      final cached = _charactersBox.values
          .map((e) => e.toCardModel())
          .toList();

      if (cached.isNotEmpty) {
        emit(CharactersLoaded(
          characters: cached,
          favoriteIds: _favoritesBox.values.map((e) => e.id).toSet(),
        ));
      }

      final network = await _provider.fetchCharacters(page: 1);

      final ui = network
          .map((e) => CharacterCardModel(
                id: e.id,
                name: e.name,
                imageUrl: e.imageUrl,
                location: e.location,
                status: e.status,
                species: e.species,
              ))
          .toList();

      for (final c in ui) {
        if (!_charactersBox.values.any((e) => e.id == c.id)) {
          _charactersBox.add(CharacterHiveModel.fromCardModel(c));
        }
      }

      emit(CharactersLoaded(
        characters: ui,
        favoriteIds: _favoritesBox.values.map((e) => e.id).toSet(),
      ));
    } catch (e) {
      emit(CharactersFailure(e));
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
      emit(CharactersLoaded(
        characters: s.characters,
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