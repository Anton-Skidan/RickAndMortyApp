import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:rick_and_morty_app/features/common_widgets/widgets/app_scaffold_view.dart';
import 'package:rick_and_morty_app/features/favorites_tab/bloc.dart';
import 'package:rick_and_morty_app/features/local_storage/storage.dart';
import 'package:rick_and_morty_app/features/common_widgets/common_widgets.dart';
import 'package:rick_and_morty_app/features/favorites_tab/models/favorites_sort_type.dart';
import 'package:rick_and_morty_app/main/theme_notifier.dart';

class FavoritesScreen extends StatefulWidget {
  final ThemeNotifier themeNotifier;

  const FavoritesScreen({super.key, required this.themeNotifier});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late final FavoritesBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = FavoritesBloc(Hive.box<CharacterHiveModel>('favorites'))
      ..add(LoadFavorites());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: AppScaffoldView(
        title: 'Избранное',
        themeNotifier: widget.themeNotifier,
        actions: [
          PopupMenuButton<FavoriteSortType>(
            onSelected: (s) => context.read<FavoritesBloc>().add(ChangeSort(s)),
            itemBuilder: (_) => const [
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

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
