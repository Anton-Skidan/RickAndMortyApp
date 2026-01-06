import 'characters_request_repository.dart';
import 'models/character_network_model.dart';

abstract class AbstractCharactersProvider {
  Future<List<CharacterNetworkModel>> fetchCharacters({int page});
}

class CharactersProvider implements AbstractCharactersProvider {
  final CharactersRepository _repository;

  CharactersProvider(this._repository);

  @override
  Future<List<CharacterNetworkModel>> fetchCharacters({int page = 1}) {
    return _repository.fetchCharacters(page: page);
  }
}