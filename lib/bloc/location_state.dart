import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class LocationState {}

class LocationInitial extends LocationState {}
class LocationLoading extends LocationState {}
class LocationLoaded extends LocationState {
  final LatLng position;
  LocationLoaded(this.position);
}

class LocationError extends LocationState {
  final String message;
  LocationError(this.message);
}

