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
      imageUrl: json['image'] as String,
      name: json['name'] as String,
      location: (json['location']?['name'] ?? '') as String,
      status: json['status'] as String,
      species: json['species'] as String, 
      id: json['id'] as int,
    );
  }
}