import 'package:flutter/material.dart';
import 'character_card_view.dart';
import '../models/character_model.dart';

class CharactersListView extends StatelessWidget {
  static const EdgeInsets _padding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 16,
  );
  static const double _itemSpacing = 16;

  final List<CharacterCardModel> characters;
  final Set<int>? favoriteIds;
  final ValueChanged<CharacterCardModel>? onAction;
  final bool isRemovable;
  final String emptyText;

  const CharactersListView({
    super.key,
    required this.characters,
    this.favoriteIds,
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
      padding: _padding,
      itemCount: characters.length,
      separatorBuilder: (_, __) => const SizedBox(height: _itemSpacing),
      itemBuilder: (context, index) {
        final character = characters[index];
        final bool isCharacterFavorite =
            !isRemovable && (favoriteIds?.contains(character.id) ?? false);

        return CharacterCard(
          key: ValueKey(character.id),
          character: character,
          isFavorite: isCharacterFavorite,
          isRemovable: isRemovable,
          onAction: onAction,
        );
      },
    );
  }
}
