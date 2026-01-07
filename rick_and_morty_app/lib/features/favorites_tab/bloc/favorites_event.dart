part of 'favorites_bloc.dart';

abstract class FavoritesEvent {}

class LoadFavorites extends FavoritesEvent {}

class RemoveFavorite extends FavoritesEvent {
  final CharacterCardModel character;
  RemoveFavorite(this.character);
}

class ChangeSort extends FavoritesEvent {
  final FavoriteSortType sortType;
  ChangeSort(this.sortType);
}
