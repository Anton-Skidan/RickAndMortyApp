import 'package:flutter/material.dart';
import 'package:rick_and_morty_app/features/characters_tab/models/character_model.dart';
import 'character_card_view.dart';

class CharactersScreen extends StatelessWidget {
  const CharactersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final characters = _mockCharacters;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Персонажи'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: characters.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            return CharacterCard(
              character: characters[index],
            );
          },
        ),
      ),
    );
  }
}

final List<CharacterCardModel> _mockCharacters = [
   CharacterCardModel(
    imageUrl: 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
    name: 'Rick Sanchez',
    location: 'Earth (Replacement Dimension)',
    status: 'Alive',
    species: 'Human',
  ),
  CharacterCardModel(
    imageUrl: 'https://rickandmortyapi.com/api/character/avatar/2.jpeg',
    name: 'Morty Smith',
    location: 'Earth (Replacement Dimension)',
    status: 'Alive',
    species: 'Human',
  ),
  CharacterCardModel(
    imageUrl: 'https://rickandmortyapi.com/api/character/avatar/3.jpeg',
    name: 'Summer Smith',
    location: 'Earth (Replacement Dimension)',
    status: 'Alive',
    species: 'Human',
  ),
  CharacterCardModel(
    imageUrl: 'https://rickandmortyapi.com/api/character/avatar/4.jpeg',
    name: 'Beth Smith',
    location: 'Earth (Replacement Dimension)',
    status: 'Alive',
    species: 'Human',
  ),
  CharacterCardModel(
    imageUrl: 'https://rickandmortyapi.com/api/character/avatar/5.jpeg',
    name: 'Jerry Smith',
    location: 'Earth (Replacement Dimension)',
    status: 'Alive',
    species: 'Human',
  ),
];
