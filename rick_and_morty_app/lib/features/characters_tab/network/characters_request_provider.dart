import 'characters_request_repository.dart';
import 'models/character_network_model.dart';

abstract class CharactersRequestProvider {
  Future<List<CharacterNetworkModel>> fetchCharacters({int page});
}

class CharactersProvider implements CharactersRequestProvider {
  final CharactersRequestRepository _repository;

  CharactersProvider(this._repository);

  @override
  Future<List<CharacterNetworkModel>> fetchCharacters({int page = 1}) {
    return _repository.fetchCharacters(page: page);
  }
}
