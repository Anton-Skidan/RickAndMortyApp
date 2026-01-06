import 'package:flutter/material.dart';
import 'character_card_view.dart';
import 'models/character_model.dart';

class CharactersListView extends StatelessWidget {
  final List<CharacterCardModel> characters;

  final Set<CharacterCardModel>? favorites;

  final ValueChanged<CharacterCardModel>? onAction;

  final bool isRemovable;

  final String emptyText;

  const CharactersListView({
    super.key,
    required this.characters,
    this.favorites,
    this.onAction,
    this.isRemovable = false,
    this.emptyText = 'Список пуст',
  });

  @override
  Widget build(BuildContext context) {
    if (characters.isEmpty) {
      return Center(child: Text(emptyText));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: characters.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final character = characters[index];

        final isFavorite = !isRemovable &&
            (favorites?.contains(character) ?? false);

        return CharacterCard(
          character: character,
          isFavorite: isFavorite,
          isRemovable: isRemovable,
          onAction: onAction,
        );
      },
    );
  }
}