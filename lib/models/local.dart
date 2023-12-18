import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';

part 'local.g.dart'; // Arquivo gerado pelo Hive

@HiveType(typeId: 0)
class Local {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final LocalType type;

  @HiveField(2)
  final String address;

  @HiveField(3)
  final String? fotoPath;

  @HiveField(4)
  final LatLng coords;

  Local({required this.name, required this.type, required this.address, this.fotoPath, required this.coords});
}

@HiveType(typeId: 1)
enum LocalType {
  @HiveField(0)
  Lazer,

  @HiveField(1)
  HistoriaCultura,

  @HiveField(2)
  Gastronomia,
}

@HiveType(typeId: 2)
class LatLngAdapter extends TypeAdapter<LatLng> {
  @override
  final typeId = 2;

  @override
  LatLng read(BinaryReader reader) {
    final lat = reader.readDouble();
    final lng = reader.readDouble();
    return LatLng(lat, lng);
  }

  @override
  void write(BinaryWriter writer, LatLng obj) {
    writer.writeDouble(obj.latitude);
    writer.writeDouble(obj.longitude);
  }
}

