import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:rick_and_morty_app/features/common_widgets/common_widgets.dart';
import 'package:rick_and_morty_app/features/favorites_tab/models/favorites_sort_type.dart';
import 'package:rick_and_morty_app/features/local_storage/storage.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc(this._favoritesBox) : super(FavoritesLoading()) {
    on<LoadFavorites>(_onLoad);
    on<RemoveFavorite>(_onRemove);
    on<ChangeSort>(_onSort);

    _subscription = _favoritesBox.watch().listen((_) {
      add(LoadFavorites());
    });
  }

  final Box<CharacterHiveModel> _favoritesBox;
  late final StreamSubscription<BoxEvent> _subscription;

  FavoriteSortType _currentSort = FavoriteSortType.name;

  void _onLoad(LoadFavorites event, Emitter<FavoritesState> emit) {
    _emitSorted(emit);
  }

  void _onRemove(RemoveFavorite event, Emitter<FavoritesState> emit) {
    for (final item in _favoritesBox.values) {
      if (item.id == event.character.id) {
        item.delete();
        break;
      }
    }
    _emitSorted(emit);
  }

  void _onSort(ChangeSort event, Emitter<FavoritesState> emit) {
    _currentSort = event.sortType;
    _emitSorted(emit);
  }

  void _emitSorted(Emitter<FavoritesState> emit) {
    emit(
      FavoritesLoaded(favorites: _sortedFavorites(), sortType: _currentSort),
    );
  }

  List<CharacterCardModel> _sortedFavorites() {
    final favorites = _favoritesBox.values.map((e) => e.toCardModel()).toList();

    switch (_currentSort) {
      case FavoriteSortType.name:
        favorites.sort((a, b) => a.name.compareTo(b.name));
        break;
      case FavoriteSortType.status:
        favorites.sort((a, b) => a.status.compareTo(b.status));
        break;
    }

    return favorites;
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
