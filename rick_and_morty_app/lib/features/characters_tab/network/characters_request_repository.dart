import 'package:dio/dio.dart';
import 'models/character_network_model.dart';

class CharactersRequestRepository {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://rickandmortyapi.com/api",
      connectTimeout: const Duration(seconds: 12),
      receiveTimeout: const Duration(seconds: 12),
      responseType: ResponseType.json,
    ),
  );

  Future<List<CharacterNetworkModel>> fetchCharacters({int page = 1}) async {
    try {
      final response = await _dio.get(
        '/character',
        queryParameters: {'page': page},
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final results = data['results'] as List<dynamic>;

        return results.map((e) => CharacterNetworkModel.fromJson(e)).toList();
      }
      return [];
    } on DioException {
      return [];
    } catch (e) {
      return [];
    }
  }
}
