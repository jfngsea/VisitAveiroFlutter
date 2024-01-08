import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermissionList(List<Permission> permissions, Function onAllGranted) async {
  int permisions_granted =0;
  try {
    for (var element in permissions) {
      if(!await element.status.isGranted){
        var status = await element.request();
        if(status.isGranted){
          permisions_granted++;
        }
      } else {
        permisions_granted++;
      }

    }
    if(permisions_granted==permissions.length){
      onAllGranted();
    }

  } catch (e) {
    debugPrint('$e');
  }
}