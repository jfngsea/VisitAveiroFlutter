
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:visit_aveiro/components/immersive_camera/camera_view.dart';
import 'package:visit_aveiro/components/immersive_camera/poi_location.dart';
import 'package:visit_aveiro/models/PoIModel.dart';

import '../../utils/permissions.dart';

class ImmersiveCameraWidget extends StatefulWidget {
  const ImmersiveCameraWidget({super.key});

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
        PoILocation(poi: PoIModel(40.639260, -7.680924),),
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

