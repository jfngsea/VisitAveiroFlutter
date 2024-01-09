// ignore_for_file: library_private_types_in_public_api, must_be_immutable

import 'package:VisitAveiroFlutter/models/local.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
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
  GoogleMapController ? mapController;
  LatLng? currentPosition;
  Set<Marker> markers = {};

@override
void initState() {
  super.initState();
  _loadAllLocals();
  final locationBloc = BlocProvider.of<LocationBloc>(context, listen: false);
  _checkAndRequestLocationPermission().then((_) {
    if (widget.coords != null) {
      currentPosition = widget.coords;
      _addCurrentLocationMarker(currentPosition!);
      _goToCurrentPosition(currentPosition!);
    } else {
      locationBloc.add(FetchCurrentLocation());
    }
  });
}



  Future<void> _checkAndRequestLocationPermission() async {
  var status = await Permission.location.status;
  if (!status.isGranted) {
    status = await Permission.location.request();
    if (!status.isGranted) {
      
    }
  }
}

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _goToCurrentPosition(LatLng position) {
    mapController?.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: position, zoom: 14.0),
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
      icon: BitmapDescriptor.defaultMarkerWithHue((BitmapDescriptor.hueGreen))

    );

    setState(() {
      markers.add(marker);
    });
  }


  void _loadAllLocals(){
    final box = Hive.box<Local>('Locals');

      setState((){

        markers.addAll(box.values.map((local) => Marker(
          markerId: MarkerId(local.name),
          position: LatLng(local.coords.latitude, local.coords.longitude),
          infoWindow: InfoWindow(title: local.name, snippet: local.address),
        ),).toList());
      });
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
      appBar: AppBar(
        title: const Text('Map' , style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
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
                    icon: BitmapDescriptor.defaultMarkerWithHue((BitmapDescriptor.hueGreen))
                  ));
                });
                _loadAllLocals();
                _goToCurrentPosition(newPos);
              }
            },
            child: const SizedBox.shrink(), 
          ),
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
                    zoom: 14.0,
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


