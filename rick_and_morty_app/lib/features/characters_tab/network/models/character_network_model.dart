import 'package:rick_and_morty_app/features/common_widgets/common_widgets.dart';

class CharacterNetworkModel {
  final int id;
  final String imageUrl;
  final String name;
  final String location;
  final String status;
  final String species;

  CharacterNetworkModel({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.location,
    required this.status,
    required this.species,
  });

  factory CharacterNetworkModel.fromJson(Map<String, dynamic> json) {
    return CharacterNetworkModel(
      id: json['id'] as int,
      imageUrl: json['image'] as String,
      name: json['name'] as String,
      location: (json['location']?['name'] ?? '') as String,
      status: json['status'] as String,
      species: json['species'] as String,
    );
  }

  CharacterCardModel toCardModel() => CharacterCardModel(
        id: id,
        name: name,
        imageUrl: imageUrl,
        location: location,
        status: status,
        species: species,
      );
}