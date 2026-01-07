part of 'characters_bloc.dart';

abstract class CharactersState {}

class CharactersInitial extends CharactersState {}

class CharactersLoading extends CharactersState {}

class CharactersLoaded extends CharactersState {
  final List<CharacterCardModel> characters;
  final Set<int> favoriteIds;
  final bool hasMore;
  final bool isPageLoading;

  CharactersLoaded({
    required this.characters,
    required this.favoriteIds,
    this.hasMore = true,
    this.isPageLoading = false,
  });

  CharactersLoaded copyWith({
    List<CharacterCardModel>? characters,
    Set<int>? favoriteIds,
    bool? hasMore,
    bool? isPageLoading,
  }) {
    return CharactersLoaded(
      characters: characters ?? this.characters,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      hasMore: hasMore ?? this.hasMore,
      isPageLoading: isPageLoading ?? this.isPageLoading,
    );
  }
}

class CharactersFailure extends CharactersState {
  final Object error;
  CharactersFailure(this.error);
}