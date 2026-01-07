import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:rick_and_morty_app/features/characters_tab/bloc.dart';
import 'package:rick_and_morty_app/features/common_widgets/widgets/app_scaffold_view.dart';
import 'package:rick_and_morty_app/features/local_storage/storage.dart';
import 'package:rick_and_morty_app/features/characters_tab/network/characters_network.dart';
import 'package:rick_and_morty_app/features/common_widgets/common_widgets.dart';
import 'package:rick_and_morty_app/main/theme_notifier.dart';

class CharactersScreen extends StatefulWidget {
  final ThemeNotifier themeNotifier;

  const CharactersScreen({super.key, required this.themeNotifier});

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  late final ScrollController _scrollController;
  late final CharactersBloc _bloc;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);

    _bloc = CharactersBloc(
      GetIt.I<CharactersRequestProvider>(),
      Hive.box<CharacterHiveModel>('characters'),
      Hive.box<CharacterHiveModel>('favorites'),
    )..add(LoadCharacters());
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final threshold = _scrollController.position.maxScrollExtent - 200;
    if (_scrollController.position.pixels >= threshold) {
      _bloc.add(LoadNextPage());
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: AppScaffoldView(
        title: 'Персонажи',
        themeNotifier: widget.themeNotifier,
        body: BlocBuilder<CharactersBloc, CharactersState>(
          builder: (context, state) {
            if (state is CharactersLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CharactersFailure) {
              return const Center(child: Text('Ошибка загрузки персонажей'));
            }

            if (state is CharactersLoaded) {
              return ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount:
                    state.characters.length + (state.isPageLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= state.characters.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final character = state.characters[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: CharacterCard(
                      character: character,
                      isFavorite: state.favoriteIds.contains(character.id),
                      onAction: (c) => context.read<CharactersBloc>().add(
                        ToggleFavoriteCharacter(c),
                      ),
                    ),
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
