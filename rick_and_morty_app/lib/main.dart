import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rick_and_morty_app/app.dart';
import 'package:rick_and_morty_app/features/characters_tab/localStorage/storage.dart';
import 'package:rick_and_morty_app/features/characters_tab/network/characters_network.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final getIt = GetIt.instance;
  getIt.registerLazySingleton<CharactersRepository>(() => CharactersRepository());
  getIt.registerLazySingleton<AbstractCharactersProvider>(
    () => CharactersProvider(getIt<CharactersRepository>()),
  );

  await Hive.initFlutter();

  Hive.registerAdapter(CharacterHiveModelAdapter());
  await Hive.openBox<CharacterHiveModel>('characters');
  await Hive.openBox<CharacterHiveModel>('favorites');
  
  runApp(const RickAndMortyTestApp());
}