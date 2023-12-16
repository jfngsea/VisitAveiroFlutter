// ignore_for_file: library_private_types_in_public_api, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import '../bloc/location_bloc.dart';
import '../bloc/location_event.dart';
import '../bloc/location_state.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key, this.coords}) : super(key: key);
  final LatLng? coords;

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  LatLng? currentPosition;
  Set<Marker> markers = {};

@override
void initState() {
  super.initState();
  final locationBloc = BlocProvider.of<LocationBloc>(context, listen: false);
  _checkAndRequestLocationPermission().then((_) {
    if (widget.coords != null) {
      // Se coordenadas foram passadas diretamente, use-as
      currentPosition = widget.coords;
      _addCurrentLocationMarker(currentPosition!);
      _goToCurrentPosition(currentPosition!);
    } else {
      // Se não, busca a localização atual
      locationBloc.add(FetchCurrentLocation());
    }
  });
}



  Future<void> _checkAndRequestLocationPermission() async {
  var status = await Permission.location.status;
  if (!status.isGranted) {
    status = await Permission.location.request();
    if (!status.isGranted) {
      // Lide com a negação da permissão aqui
    }
  }
}

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _goToCurrentPosition(LatLng position) {
    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: position, zoom: 15.0),
    ));
    _addCurrentLocationMarker(position);
  }

  void _addCurrentLocationMarker(LatLng position) {
    final marker = Marker(
      markerId: const MarkerId("current_location"),
      position: position,
      infoWindow: const InfoWindow(
        title: 'Localização Atual',
      ),
    );

    setState(() {
      markers.clear();
      markers.add(marker);
    });
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
      appBar: AppBar(
        title: const Text('Localização com BLoC'),
      ),
      body: Column(
        children: [
          // BlocListener com um widget filho vazio
          BlocListener<LocationBloc, LocationState>(
            listener: (context, state) {
              if (state is LocationLoaded) {
                final newPos = state.position;
                setState(() {
                  currentPosition = newPos;
                  markers.clear();
                  markers.add(Marker(
                    markerId: const MarkerId("current_location"),
                    position: newPos,
                    infoWindow: const InfoWindow(title: 'Localização Atual'),
                  ));
                });
                _goToCurrentPosition(newPos);
              }
            },
            child: const SizedBox.shrink(), // Widget filho vazio
          ),
          // BlocBuilder separado
          Expanded(
            child: BlocBuilder<LocationBloc, LocationState>(
              builder: (context, state) {
                if (state is LocationLoading || currentPosition == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                return GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: currentPosition!,
                    zoom: 11.0,
                  ),
                  markers: markers,
                ); 
              },
            ),
          ),
        ],
      ),
    );
}

}


