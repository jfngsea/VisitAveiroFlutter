
import 'dart:async';

import 'package:VisitAveiroFlutter/components/immersive_camera/poi_location.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';


import '../../models/local.dart';
import '../../utils/permissions.dart';
import 'camera_view.dart';

class ImmersiveCameraWidget extends StatefulWidget {
  const ImmersiveCameraWidget({super.key, required this.poi});

  final Local poi;

  @override
  State<ImmersiveCameraWidget> createState() => _ImmersiveCameraWidgetState();
}

class _ImmersiveCameraWidgetState extends State<ImmersiveCameraWidget> {
  List<Permission> statuses = [
    Permission.location,
    Permission.camera,
  ];

  bool hasPermissions = false;

  //StreamSubscription<Position> positionStream =null;

  @override
  void initState() {
    super.initState();
    requestPermissions();

  }
  @override
  Widget build(BuildContext context) {
    if(!hasPermissions){
      return Column(
        children: [
          Text("This feature requires Camera and Localizzation Permissions!"),
          MaterialButton(onPressed: (){requestPermissions();}, child: Text("request"),),
        ],
      );
    }

    return Stack(
      children: [
        CameraView(),
        PoILocation(poi: widget.poi,),
      ],
    );
  }

  Future<void> requestPermissions() async {
    return requestPermissionList(statuses, (){
      setState(() {
        hasPermissions=true;
      });
    });
  }
}

