part of 'characters_bloc.dart';

abstract class CharactersEvent {}

class LoadCharacters extends CharactersEvent {}

class ToggleFavoriteCharacter extends CharactersEvent {
  final CharacterCardModel character;
  ToggleFavoriteCharacter(this.character);
}

class _RefreshFavorites extends CharactersEvent {}