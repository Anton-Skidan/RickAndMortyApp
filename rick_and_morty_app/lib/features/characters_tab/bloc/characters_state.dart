part of 'characters_bloc.dart';

abstract class CharactersState {}

class CharactersInitial extends CharactersState {}

class CharactersLoading extends CharactersState {}

class CharactersLoaded extends CharactersState {
  final List<CharacterCardModel> characters;
  final Set<int> favoriteIds;

  CharactersLoaded({
    required this.characters,
    required this.favoriteIds,
  });
}

class CharactersFailure extends CharactersState {
  final Object error;
  CharactersFailure(this.error);
}