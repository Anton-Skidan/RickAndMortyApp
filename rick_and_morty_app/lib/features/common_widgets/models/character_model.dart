class CharacterCardModel {
  final String imageUrl;
  final String name;
  final String location;
  final String status;
  final String species;

  CharacterCardModel({
    required this.imageUrl,
    required this.name,
    required this.location,
    required this.status,
    required this.species,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CharacterCardModel && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}
