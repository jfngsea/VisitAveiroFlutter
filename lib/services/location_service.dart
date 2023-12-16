import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';


class LocationService {
    Future<LatLng> getCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return LatLng(position.latitude, position.longitude);
  }


  Future<LatLng> getLatLngFromAddress(String address) async {
  final url = 'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=AIzaSyAlYO_XWTGLYO_CvtzdcL9e_cvHC8dk0Us';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    if (jsonResponse['results'].isEmpty) {
      throw Exception('Endereço não encontrado');
    }
    final result = jsonResponse['results'][0]['geometry']['location'];
    return LatLng(result['lat'], result['lng']);
  } else {
    throw Exception('Erro ao buscar o endereço');
  }
}

Future<String> getAddressFromLatLng(double latitude, double longitude) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      // Construir o endereço completo
      String address = "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";
      return address;
    } else {
      return "Endereço não encontrado";
    }
  } catch (e) {
    print(e);
    return "Erro ao obter endereço";
  }
}

}