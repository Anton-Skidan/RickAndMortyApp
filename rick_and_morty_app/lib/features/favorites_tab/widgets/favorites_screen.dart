import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:rick_and_morty_app/features/favorites_tab/bloc.dart';
import 'package:rick_and_morty_app/features/local_storage/storage.dart';
import 'package:rick_and_morty_app/features/common_widgets/common_widgets.dart';
import 'package:rick_and_morty_app/features/favorites_tab/models/favorites_sort_type.dart';

class FavoritesScreen extends StatelessWidget {
  final ThemeNotifier themeNotifier;

  const FavoritesScreen({super.key, required this.themeNotifier});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FavoritesBloc(
        Hive.box<CharacterHiveModel>('favorites'),
      )..add(LoadFavorites()),
      child: Scaffold(
        appBar: MainAppBar(
          title: 'Избранное',
          themeNotifier: themeNotifier,
          actions: [
            PopupMenuButton<FavoriteSortType>(
              onSelected: (s) =>
                  context.read<FavoritesBloc>().add(ChangeSort(s)),
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: FavoriteSortType.name,
                  child: Text('Сортировать по имени'),
                ),
                PopupMenuItem(
                  value: FavoriteSortType.status,
                  child: Text('Сортировать по статусу'),
                ),
              ],
            ),
          ],
        ),
        body: BlocBuilder<FavoritesBloc, FavoritesState>(
          builder: (context, state) {
            if (state is FavoritesLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is FavoritesLoaded) {
              return CharactersListView(
                characters: state.favorites,
                isRemovable: true,
                onAction: (c) =>
                    context.read<FavoritesBloc>().add(RemoveFavorite(c)),
                emptyText: 'Нет избранных персонажей',
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}