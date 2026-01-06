import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rick_and_morty_app/app.dart';
import 'package:rick_and_morty_app/features/characters_tab/network/characters_network.dart';

void main() {
  final getIt = GetIt.instance;

  getIt.registerLazySingleton<CharactersRepository>(() => CharactersRepository());

  getIt.registerLazySingleton<AbstractCharactersProvider>(
    () => CharactersProvider(getIt<CharactersRepository>()),
  );

  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const RickAndMortyTestApp());
}