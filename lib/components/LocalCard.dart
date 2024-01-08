import 'package:flutter/material.dart';
import 'dart:io';
import '../models/local.dart';
import '../views/map_page.dart';
import 'immersive_camera/imersive_camera.dart';
import 'package:cached_network_image/cached_network_image.dart';

class LocalCard extends StatelessWidget {
  const LocalCard({super.key, required this.local, this.onDeleteClick});
  final Local local;
  final Function(Local)? onDeleteClick;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          GestureDetector(
            onTap: () => _showFullImage(context, local.fotoPath),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                local.fotoPath != null
                    ? SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Image(
                      image: CachedNetworkImageProvider(local.fotoPath!),
                    fit:  BoxFit.cover,
                  )
                )
                    : const SizedBox(
                    height: 200, child: Placeholder()),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    color: Colors.black.withOpacity(0.5),
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0),
                    child: Text(
                      local.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            offset: Offset(1.0, 1.0),
                            blurRadius: 3.0,
                            color:
                            Color.fromARGB(255, 0, 0, 0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(local.address),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _openMapPage(context, local),
                child: const Text('Location'),
              ),
              ElevatedButton(
                onPressed: () => _openImmersiveCameraPage(context, local),
                child: const Text('Get Me There'),
              ),
              if(onDeleteClick!=null)
                ElevatedButton(
                  onPressed: () => onDeleteClick!(local),
                  child: const Text('Delete', style: TextStyle(color: Colors.red),),
                ),
            ],
          ),

        ],
      ),
    );
  }

  void _showFullImage(BuildContext context, String? imagePath) {
    if (imagePath == null) return;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Image.file(File(imagePath), fit: BoxFit.contain),
        );
      },
    );
  }
  void _openMapPage(BuildContext context, Local local) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapPage(coords: local.coords),
      ),
    );
  }


  void _openImmersiveCameraPage(BuildContext context, Local local) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImmersiveCameraWidget(poi: local),
      ),
    );
  }
}