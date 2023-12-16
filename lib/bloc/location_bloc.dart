import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project_test/services/location_service.dart';
import 'location_event.dart';
import 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationService locationService;

  LocationBloc({required this.locationService}) : super(LocationInitial()) {
    on<FetchCurrentLocation>(_onFetchCurrentLocation);
  }

  Future<void> _onFetchCurrentLocation(FetchCurrentLocation event, Emitter<LocationState> emit) async {
  emit(LocationLoading());
  try {
    final latLng = await locationService.getCurrentLocation();
    print("Emitindo LocationLoaded com posição: $latLng");
    emit(LocationLoaded(latLng));
  } catch (error) {
    emit(LocationError(error.toString()));
  }
}



  Future<void> _checkAndRequestLocationPermission() async {
  var status = await Permission.location.status;
  if (!status.isGranted) {
    status = await Permission.location.request();
    if (!status.isGranted) {
      throw Exception('Permissão de localização negada.');
    }
  }
}



}
