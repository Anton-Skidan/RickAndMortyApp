// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CharacterHiveModelAdapter extends TypeAdapter<CharacterHiveModel> {
  @override
  final int typeId = 0;

  @override
  CharacterHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CharacterHiveModel(
      name: fields[0] as String,
      imageUrl: fields[1] as String,
      location: fields[2] as String,
      status: fields[3] as String,
      species: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CharacterHiveModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.imageUrl)
      ..writeByte(2)
      ..write(obj.location)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.species);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharacterHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
