import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  String err = "";

  CameraController? controller;
  bool isCameraAuthorize = false;
  bool isCameraInitialize = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();

  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // todo: better permission screen
    if (!isCameraAuthorize) {
      return Column(children: [
        Text("The following permissions are required:\nCamera"),
        MaterialButton(onPressed: reqCamPerm)
      ],);
    }

    if (!isCameraInitialize) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (isCameraAuthorize && isCameraInitialize) {
      return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: CameraPreview(controller!),
      );
    }

    return Text("Error while getting camera.");
  }

  Future<void> _initializeCamera() async {
    try {
      await reqCamPerm();
      if (isCameraAuthorize) {
        final cameras = await availableCameras();
        controller = CameraController(
          cameras[0],
          ResolutionPreset.max,
          enableAudio: false,
        );
        await controller?.initialize();
        setState(() {
          isCameraInitialize = true;
        });
      }
    } catch (ex) {
      setState(() {
        err = 'On error when camera initialize';
        isCameraInitialize = false;
      });
    } finally {
      setState(() {});
    }
  }

  Future<void> reqCamPerm(){
    return _requestCameraAuthorization(() {
      setState(() {
        isCameraAuthorize = true;
      });
    }, () {
      setState(() {
        err = 'Camera need authorization permission';
      });
    });
  }
}

Future<void> _requestCameraAuthorization(
    Function onSuccess, Function onFail) async {
  var isGranted = await Permission.camera.isGranted;
  if (!isGranted) {
    await Permission.camera.request();
    isGranted = await Permission.camera.isGranted;
    if (!isGranted) {
      onFail();
    } else {
      onSuccess();
    }
  } else {
    onSuccess();
  }
}
