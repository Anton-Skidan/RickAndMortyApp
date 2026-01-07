part of 'favorites_bloc.dart';

abstract class FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<CharacterCardModel> favorites;
  final FavoriteSortType sortType;

  FavoritesLoaded({required this.favorites, required this.sortType});
}
