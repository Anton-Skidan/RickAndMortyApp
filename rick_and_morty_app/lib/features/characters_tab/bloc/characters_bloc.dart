import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:rick_and_morty_app/features/characters_tab/network/characters_network.dart';
import 'package:rick_and_morty_app/features/common_widgets/common_widgets.dart';
import 'package:rick_and_morty_app/features/local_storage/storage.dart';

part 'characters_event.dart';
part 'characters_state.dart';

class CharactersBloc extends Bloc<CharactersEvent, CharactersState> {
  CharactersBloc(this._requestProvider, this._charactersBox, this._favoritesBox)
    : super(CharactersInitial()) {
    on<LoadCharacters>(_handleInitialLoad);
    on<LoadNextPage>(_handlePagination);
    on<ToggleFavoriteCharacter>(_handleToggleFavorite);
    on<_RefreshFavorites>(_handleFavoritesSync);

    _favoritesSubscription = _favoritesBox.watch().listen((_) {
      add(_RefreshFavorites());
    });
  }

  final CharactersRequestProvider _requestProvider;
  final Box<CharacterHiveModel> _charactersBox;
  final Box<CharacterHiveModel> _favoritesBox;

  late final StreamSubscription<BoxEvent> _favoritesSubscription;

  int _currentPage = 1;
  bool _hasMorePages = true;
  bool _isRequestInProgress = false;

  Future<void> _handleInitialLoad(
    LoadCharacters event,
    Emitter<CharactersState> emit,
  ) async {
    emit(CharactersLoading());

    final cachedCharacters = _charactersBox.values
        .map((hiveModel) => hiveModel.toCardModel())
        .toList();

    if (cachedCharacters.isNotEmpty) {
      emit(_buildLoadedState(cachedCharacters));
    }

    try {
      final networkCharacters = await _requestProvider.fetchCharacters(page: 1);

      final mappedCharacters = networkCharacters
          .map(_mapNetworkToCardModel)
          .toList();

      _persistNewCharacters(mappedCharacters);

      _currentPage = 1;
      _hasMorePages = mappedCharacters.isNotEmpty;

      emit(_buildLoadedState(mappedCharacters));
    } catch (exception) {
      emit(CharactersFailure(exception));
    }
  }

  Future<void> _handlePagination(
    LoadNextPage event,
    Emitter<CharactersState> emit,
  ) async {
    if (_isRequestInProgress || !_hasMorePages || state is! CharactersLoaded) {
      return;
    }

    _isRequestInProgress = true;

    final currentState = state as CharactersLoaded;
    emit(currentState.copyWith(isPageLoading: true));

    try {
      final nextPage = _currentPage + 1;
      final networkCharacters = await _requestProvider.fetchCharacters(
        page: nextPage,
      );

      final mappedCharacters = networkCharacters
          .map(_mapNetworkToCardModel)
          .toList();

      _persistNewCharacters(mappedCharacters);

      _currentPage = nextPage;
      _hasMorePages = mappedCharacters.isNotEmpty;

      emit(
        currentState.copyWith(
          characters: [...currentState.characters, ...mappedCharacters],
          hasMore: _hasMorePages,
          isPageLoading: false,
        ),
      );
    } finally {
      _isRequestInProgress = false;
    }
  }

  void _handleToggleFavorite(
    ToggleFavoriteCharacter event,
    Emitter<CharactersState> emit,
  ) {
    CharacterHiveModel? existingFavorite;
    try {
      existingFavorite = _favoritesBox.values
          .cast<CharacterHiveModel>()
          .firstWhere((favorite) => favorite.id == event.character.id);
    } catch (_) {
      existingFavorite = null;
    }

    if (existingFavorite != null) {
      existingFavorite.delete();
    } else {
      _favoritesBox.add(CharacterHiveModel.fromCardModel(event.character));
    }
  }

  void _handleFavoritesSync(
    _RefreshFavorites event,
    Emitter<CharactersState> emit,
  ) {
    if (state is CharactersLoaded) {
      final currentState = state as CharactersLoaded;
      emit(_buildLoadedState(currentState.characters));
    }
  }

  CharactersLoaded _buildLoadedState(List<CharacterCardModel> characters) {
    return CharactersLoaded(
      characters: characters,
      favoriteIds: _favoritesBox.values.map((favorite) => favorite.id).toSet(),
      hasMore: _hasMorePages,
    );
  }

  CharacterCardModel _mapNetworkToCardModel(dynamic networkModel) {
    return CharacterCardModel(
      id: networkModel.id,
      name: networkModel.name,
      imageUrl: networkModel.imageUrl,
      location: networkModel.location,
      status: networkModel.status,
      species: networkModel.species,
    );
  }

  void _persistNewCharacters(List<CharacterCardModel> characters) {
    final existingIds = _charactersBox.values.map((c) => c.id).toSet();

    for (final character in characters) {
      if (!existingIds.contains(character.id)) {
        _charactersBox.add(CharacterHiveModel.fromCardModel(character));
      }
    }
  }

  @override
  Future<void> close() {
    _favoritesSubscription.cancel();
    return super.close();
  }
}
