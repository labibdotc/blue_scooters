import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:bluescooters/camera_common.dart';
import 'package:bluescooters/screens/DisplayPictureScreen.dart';



/// CameraApp is the Main Application.
class CameraApp extends StatefulWidget {
  final String scooter_id;
  final int scooter_start_price;
  // final Future<void> Function(BuildContext context, String imagePath, DateTime dateTime, int scooter_start_price) onPictureSubmission;
  final Map<String,dynamic>? returnData;
  CameraApp({required this.scooter_id, required this.scooter_start_price, this.returnData});
  static const String id = "CameraApp";
  /// Default Constructor

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  late CameraController controller;
  late Future<void> cameraInitialization;


  @override
  void initState() {
    super.initState();
    controller = CameraController(Cameras!.firstWhere((e) => e.lensDirection == CameraLensDirection.front), //TODO: switch to front
      ResolutionPreset.max, // TODO: un-hardcode
        enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,); // TODO: un-hardcode
    cameraInitialization = controller.initialize();

    cameraInitialization.then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
          // Handle access errors here.
            break;
          default:
          // Handle other errors here.
            break;
        }
      }
    });
  }
  Future<void> captureAndDisplayImage() async {
    try {
      await cameraInitialization;
      final XFile picture = await controller.takePicture();
      // You can now display the picture using another widget or save it to a file.
      Navigator.push(context, MaterialPageRoute(builder: (context) => DisplayPictureScreen(imagePath: picture.path, scooter_id: widget.scooter_id, scooter_start_price: widget.scooter_start_price,returnData: widget.returnData,)));
    } catch (e) {
      print("Error capturing picture: $e");
    }
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return WillPopScope(
          onWillPop: () async {
            // Custom logic codes
            // Return true to allow back navigation, false to prevent it
            return false;
          },
          child: Container()
      );
    }

    return WillPopScope(
        onWillPop: () async {
          // Custom logic codes
          // Return true to allow back navigation, false to prevent it
          return false;
        },
        child:
        MaterialApp(
          home: Scaffold(
            body: CameraPreview(controller),
            floatingActionButton: FloatingActionButton(
              onPressed: captureAndDisplayImage,
              child: Icon(Icons.camera),
            ),
          ),

    )
    );
  }
}