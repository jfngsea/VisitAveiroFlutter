// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalAdapter extends TypeAdapter<Local> {
  @override
  final int typeId = 0;

  @override
  Local read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Local(
      name: fields[0] as String,
      type: fields[1] as LocalType,
      address: fields[2] as String,
      fotoPath: fields[3] as String?,
      coords: fields[4] as LatLng,
    );
  }

  @override
  void write(BinaryWriter writer, Local obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.address)
      ..writeByte(3)
      ..write(obj.fotoPath)
      ..writeByte(4)
      ..write(obj.coords);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LocalTypeAdapter extends TypeAdapter<LocalType> {
  @override
  final int typeId = 1;

  @override
  LocalType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return LocalType.Lazer;
      case 1:
        return LocalType.HistoriaCultura;
      case 2:
        return LocalType.Gastronomia;
      default:
        return LocalType.Lazer;
    }
  }

  @override
  void write(BinaryWriter writer, LocalType obj) {
    switch (obj) {
      case LocalType.Lazer:
        writer.writeByte(0);
        break;
      case LocalType.HistoriaCultura:
        writer.writeByte(1);
        break;
      case LocalType.Gastronomia:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
