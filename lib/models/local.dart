import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';

part 'local.g.dart'; // Arquivo gerado pelo Hive

@HiveType(typeId: 0)
class Local extends HiveObject {
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

  @HiveField(5)
  final String? userid;

  @HiveField(6)
  final String? docId;

  Local({required this.name, required this.type, required this.address, this.fotoPath, required this.coords, this.userid, this.docId});

  Local.fromJson(Map<String, dynamic> json, String docId) : this (
    name: json['name'] as String,
    type: LocalType.values.byName(json['type'] as String),
    address: json['address'] as String,
    fotoPath: json['imageUrl']??"",
    coords: LatLng(json['latitude'] as double, json['longitude'] as double),
    userid: json['userid'] as String,
    docId:  docId,
  );

  Map<String, dynamic> toJson() {
    return {
      "name":name,
      "type":type.toString().split(".")[1],
      "address":address,
      "imageUrl":fotoPath,
      "latitude":coords.latitude,
      "longitude": coords.longitude,
      "userid":userid,
    };
  }

  Local copyWith({String? name, LocalType? type, String? address, String? fotoPath, LatLng? coords, String? userid, String? docId})=> Local(
    name : name ?? this.name,
    type : type ?? this.type,
    address : address ?? this.address,
    fotoPath : fotoPath ?? this.fotoPath,
    coords : coords ?? this.coords,
    userid : userid ?? this.userid,
    docId : docId ?? this.docId,
  );

}

@HiveType(typeId: 1)
enum LocalType {
  @HiveField(0)
  Lazer,

  @HiveField(1)
  Historia,

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

