import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:rick_and_morty_app/features/characters_tab/bloc.dart';
import 'package:rick_and_morty_app/features/local_storage/storage.dart';
import 'package:rick_and_morty_app/features/characters_tab/network/characters_network.dart';
import 'package:rick_and_morty_app/features/common_widgets/common_widgets.dart';

class CharactersScreen extends StatelessWidget {
  final ThemeNotifier themeNotifier;

  const CharactersScreen({super.key, required this.themeNotifier});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CharactersBloc(
        GetIt.I<CharactersRequestProvider>(),
        Hive.box<CharacterHiveModel>('characters'),
        Hive.box<CharacterHiveModel>('favorites'),
      )..add(LoadCharacters()),
      child: Scaffold(
        appBar: MainAppBar(
          title: 'Персонажи',
          themeNotifier: themeNotifier,
        ),
        body: SafeArea(
          child: BlocBuilder<CharactersBloc, CharactersState>(
            builder: (context, state) {
              if (state is CharactersLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is CharactersFailure) {
                return const Center(child: Text('Ошибка загрузки персонажей'));
              }

              if (state is CharactersLoaded) {
                return CharactersListView(
                  characters: state.characters,
                  favoriteIds: state.favoriteIds,
                  onAction: (c) => context
                      .read<CharactersBloc>()
                      .add(ToggleFavoriteCharacter(c)),
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}