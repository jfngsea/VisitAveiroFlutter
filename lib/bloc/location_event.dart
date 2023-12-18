abstract class LocationEvent {}

class FetchCurrentLocation extends LocationEvent {}

class FetchLocationFromAddress extends LocationEvent {
  final String address;
  FetchLocationFromAddress(this.address);
}

