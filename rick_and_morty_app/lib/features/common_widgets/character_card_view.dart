import 'package:flutter/material.dart';
import 'models/character_model.dart';
import 'character_info_view.dart';

class CharacterCard extends StatelessWidget {
  final CharacterCardModel character;

  const CharacterCard({
    super.key,
    required this.character,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(character.imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.6),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                CharacterInfoView(
                  text: character.name,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 4),
                CharacterInfoView(
                  text: 'Локация: ${character.location}',
                ),
                CharacterInfoView(
                  text: 'Статус: ${character.status}',
                ),
                CharacterInfoView(
                  text: 'Тип: ${character.species}',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
