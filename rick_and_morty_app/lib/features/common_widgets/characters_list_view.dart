import 'package:flutter/material.dart';
import 'character_card_view.dart';
import 'models/character_model.dart';

class CharactersListView extends StatefulWidget {
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
  State<CharactersListView> createState() => _CharactersListViewState();
}

class _CharactersListViewState extends State<CharactersListView> {
  final _listKey = GlobalKey<AnimatedListState>();
  late List<CharacterCardModel> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.characters);
  }

  @override
  void didUpdateWidget(covariant CharactersListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.characters.length < _items.length) {
      final removed = _items
          .where((e) => !widget.characters.contains(e))
          .toList();

      for (final item in removed) {
        final index = _items.indexOf(item);
        _removeAt(index);
      }
    } else {
      _items = List.of(widget.characters);
    }
  }

  void _removeAt(int index) {
    final removedItem = _items.removeAt(index);

    _listKey.currentState?.removeItem(
      index,
      (context, animation) => SizeTransition(
        sizeFactor: animation,
        child: FadeTransition(
          opacity: animation,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: CharacterCard(character: removedItem, isRemovable: true),
          ),
        ),
      ),
      duration: const Duration(milliseconds: 280),
    );
  }

  void _onAction(CharacterCardModel character) {
    final index = _items.indexOf(character);
    if (index == -1) return;

    _removeAt(index);
    widget.onAction?.call(character);
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) {
      return Center(child: Text(widget.emptyText));
    }

    return AnimatedList(
      key: _listKey,
      padding: const EdgeInsets.all(16),
      initialItemCount: _items.length,
      itemBuilder: (context, index, animation) {
        final character = _items[index];

        final isFavorite =
            !widget.isRemovable &&
            (widget.favorites?.contains(character) ?? false);

        return SizeTransition(
          sizeFactor: animation,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: CharacterCard(
              character: character,
              isFavorite: isFavorite,
              isRemovable: widget.isRemovable,
              onAction: widget.isRemovable ? _onAction : widget.onAction,
            ),
          ),
        );
      },
    );
  }
}
