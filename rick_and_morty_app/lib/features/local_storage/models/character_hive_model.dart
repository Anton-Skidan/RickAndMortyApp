import 'package:hive/hive.dart';
import 'package:rick_and_morty_app/features/common_widgets/common_widgets.dart';

part 'character_hive_model.g.dart';

@HiveType(typeId: 1)
class CharacterHiveModel extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String imageUrl;
  @HiveField(3)
  final String location;
  @HiveField(4)
  final String status;
  @HiveField(5)
  final String species;

  CharacterHiveModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.location,
    required this.status,
    required this.species,
  });

  CharacterCardModel toCardModel() => CharacterCardModel(
    id: id,
    name: name,
    imageUrl: imageUrl,
    location: location,
    status: status,
    species: species,
  );

  factory CharacterHiveModel.fromCardModel(CharacterCardModel c) =>
      CharacterHiveModel(
        id: c.id,
        name: c.name,
        imageUrl: c.imageUrl,
        location: c.location,
        status: c.status,
        species: c.species,
      );
}
