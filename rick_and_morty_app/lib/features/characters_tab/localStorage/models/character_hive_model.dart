import 'package:hive/hive.dart';
import 'package:rick_and_morty_app/features/common_widgets/common_widgets.dart';

part 'character_hive_model.g.dart';

@HiveType(typeId: 0)
class CharacterHiveModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String imageUrl;

  @HiveField(2)
  String location;

  @HiveField(3)
  String status;

  @HiveField(4)
  String species;

  CharacterHiveModel({
    required this.name,
    required this.imageUrl,
    required this.location,
    required this.status,
    required this.species,
  });

    factory CharacterHiveModel.fromCardModel(CharacterCardModel card) {
      return CharacterHiveModel(
        name: card.name,
        imageUrl: card.imageUrl,
        location: card.location,
        status: card.status,
        species: card.species,
      );
    }

  CharacterCardModel toCardModel() {
  return CharacterCardModel(
    name: name,
    imageUrl: imageUrl,
    location: location,
    status: status,
    species: species,
  );
}
  }