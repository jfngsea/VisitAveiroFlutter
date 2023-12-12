

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';

import '../../models/PoIModel.dart';

class PoILocation extends StatefulWidget {
  const PoILocation({super.key, required this.poi});

  final PoIModel poi;


  @override
  State<PoILocation> createState() => _PoILocationState();
}

class _PoILocationState extends State<PoILocation> {
  final LocationSettings locationSettings =  AndroidSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 0,
      intervalDuration: const Duration(milliseconds: 250),

  );


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        StreamBuilder(
            stream: Geolocator.getPositionStream(locationSettings: locationSettings),
            builder: (context, snapshot) {
              if(snapshot.hasData){
                var position = snapshot.data!;
                return Column(
                  children: [
                    Text("Current Location: ${position.latitude}:${position.longitude}"),
                    Text("target Location: ${widget.poi.latitude}:${widget.poi.longitude}"),

                    Text("timestamp: ${DateTime.now().millisecondsSinceEpoch}"),
                    Text("Heading: ${position.heading}"),
                    Text("Distancia: ${Geolocator.distanceBetween(position.latitude, position.longitude, widget.poi.latitude, widget.poi.longitude)})"),
                    Text("Bearing: ${Geolocator.bearingBetween(position.latitude, position.longitude, widget.poi.latitude, widget.poi.longitude)}"),



                    StreamBuilder(
                        stream: FlutterCompass.events,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text('Error reading heading: ${snapshot.error}');
                          }

                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          double? direction = snapshot.data!.heading;

                          // if direction is null, then device does not support this sensor
                          // show error message
                          if (direction == null)
                            return Center(
                              child: Text("Device does not have sensors !"),
                            );

                          double poi_angle =-direction+Geolocator.bearingBetween(position.latitude, position.longitude, widget.poi.latitude, widget.poi.longitude);
                          double poi_angle_normalized = ((poi_angle>20? 20: poi_angle<-20? -19.9: poi_angle) +20)/40;
                          double distance = Geolocator.distanceBetween(position.latitude, position.longitude, widget.poi.latitude, widget.poi.longitude);

                          return Column(
                            children: [
                              Text("Compass data: ${direction}"),
                              Text("Angle to PoI: ${poi_angle}"),
                              SliderTheme(
                                child: Slider(value: poi_angle_normalized, onChanged: null,label: "$distance",),
                                data: SliderThemeData(
                                  activeTrackColor: Colors.transparent,
                                  overlayShape: SliderComponentShape.noOverlay,
                                  thumbShape: CustomSliderThumb(),
                                  trackHeight: 0,
                                ),
                              )

                            ],
                          );
                        }
                    ),
                  ],
                );
              }
              else if(snapshot.hasError){
                 return Text("Error: ${snapshot.error!.toString()}");
              }
              else {
                return Text("Loading location data");
              }

            },
        ),

      ],
    );
  }
}

class CustomSliderThumb extends RoundSliderThumbShape{

}
