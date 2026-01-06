import 'package:flutter/material.dart';
import 'models/character_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CharacterCard extends StatelessWidget {
  final CharacterCardModel character;
  final bool isFavorite;
  final bool isRemovable;
  final ValueChanged<CharacterCardModel>? onAction;

  const CharacterCard({
    super.key,
    required this.character,
    this.isFavorite = false,
    this.isRemovable = false,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: CachedNetworkImageProvider(character.imageUrl),
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
                    Colors.black.withValues(alpha: 0.6),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 8,
            left: 8,
            child: IconButton(
              iconSize: 32,
              icon: Icon(
                isRemovable
                    ? Icons.delete_outline
                    : isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                color: Colors.redAccent,
              ),
              onPressed: onAction == null
                  ? null
                  : () => onAction!(character),
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
                Text(
                  character.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Локация: ${character.location}',
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  'Статус: ${character.status}',
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  'Вид: ${character.species}',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
