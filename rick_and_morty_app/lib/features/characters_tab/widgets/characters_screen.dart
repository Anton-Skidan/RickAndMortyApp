import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:rick_and_morty_app/features/characters_tab/bloc.dart';
import 'package:rick_and_morty_app/features/local_storage/storage.dart';
import 'package:rick_and_morty_app/features/characters_tab/network/characters_network.dart';
import 'package:rick_and_morty_app/features/common_widgets/common_widgets.dart';

class CharactersScreen extends StatefulWidget {
  final ThemeNotifier themeNotifier;

  const CharactersScreen({super.key, required this.themeNotifier});

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CharactersBloc(
        GetIt.I<CharactersRequestProvider>(),
        Hive.box<CharacterHiveModel>('characters'),
        Hive.box<CharacterHiveModel>('favorites'),
      )..add(LoadCharacters()),
      child: Builder(
        builder: (context) {
          _scrollController.addListener(() {
            if (_scrollController.position.pixels >
                _scrollController.position.maxScrollExtent - 200) {
              context.read<CharactersBloc>().add(LoadNextPage());
            }
          });

          return Scaffold(
            appBar: MainAppBar(
              title: 'Персонажи',
              themeNotifier: widget.themeNotifier,
            ),
            body: SafeArea(
              child: BlocBuilder<CharactersBloc, CharactersState>(
                builder: (context, state) {
                  if (state is CharactersLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is CharactersFailure) {
                    return const Center(child: Text('Ошибка загрузки'));
                  }

                  if (state is CharactersLoaded) {
                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: state.characters.length +
                          (state.isPageLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= state.characters.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child:
                                Center(child: CircularProgressIndicator()),
                          );
                        }

                        final c = state.characters[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: CharacterCard(
                            character: c,
                            isFavorite:
                                state.favoriteIds.contains(c.id),
                            onAction: (c) => context
                                .read<CharactersBloc>()
                                .add(ToggleFavoriteCharacter(c)),
                          ),
                        );
                      },
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          );
        },
      ),
    );
  }
}