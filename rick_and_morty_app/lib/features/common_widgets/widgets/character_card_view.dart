import 'package:flutter/material.dart';
import '../models/character_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CharacterCard extends StatefulWidget {
  static const double height = 240;
  static const double borderRadius = 12;
  static const double iconSize = 32;

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
  State<CharacterCard> createState() => _CharacterCardState();
}

class _CharacterCardState extends State<CharacterCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    _scale = Tween<double>(
      begin: 1,
      end: 0.85,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _fade = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  Future<void> _handleRemove() async {
    if (widget.onAction == null) return;

    await _controller.forward();
    widget.onAction!(widget.character);
    _controller.reset();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          height: CharacterCard.height,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(CharacterCard.borderRadius),
            image: DecorationImage(
              image: CachedNetworkImageProvider(widget.character.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      CharacterCard.borderRadius,
                    ),
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
                  iconSize: CharacterCard.iconSize,
                  icon: Icon(
                    widget.isRemovable
                        ? Icons.delete_outline
                        : widget.isFavorite
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.redAccent,
                  ),
                  onPressed: widget.isRemovable
                      ? _handleRemove
                      : widget.onAction == null
                      ? null
                      : () => widget.onAction!(widget.character),
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
                      'Вид: ${widget.character.species}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
