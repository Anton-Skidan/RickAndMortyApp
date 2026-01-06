import 'package:flutter/material.dart';
import 'models/character_model.dart';

class CharacterCard extends StatefulWidget {
  final CharacterCardModel character;
  final ValueChanged<CharacterCardModel>? onFavoriteToggle;
  final bool isFavorite;

  const CharacterCard({
    super.key,
    required this.character,
    this.onFavoriteToggle,
    this.isFavorite = false,
  });

  @override
  State<CharacterCard> createState() => _CharacterCardState();
}

class _CharacterCardState extends State<CharacterCard> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  void _toggleFavorite() {
    setState(() => _isFavorite = !_isFavorite);
    if (widget.onFavoriteToggle != null) {
      widget.onFavoriteToggle!(widget.character);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(widget.character.imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // затемнение для текста
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
            child: GestureDetector(
              onTap: _toggleFavorite,
              child: Icon(
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.redAccent,
                size: 32,
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
                Text(
                  widget.character.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Локация: ${widget.character.location}',
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  'Статус: ${widget.character.status}',
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  'Тип: ${widget.character.species}',
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