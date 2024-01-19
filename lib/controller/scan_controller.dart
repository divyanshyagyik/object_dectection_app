import 'dart:math';
import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class ScanController extends GetxController{
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initcamera();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    cameraController.dispose();
  }
  late CameraController cameraController;
  late List<CameraDescription> cameras;
  late CameraImage cameraImage;

  var isCameraInitialized = false.obs;
  var cameraCount = 0;
  initcamera() async{
    if(await Permission.camera.request().isGranted){
      cameras = await availableCameras();
      cameraController= CameraController(
        cameras[0],
        ResolutionPreset.max,
        imageFormatGroup: await cameraController.initialize().then((value) {
          cameraCount++;
          if (cameraCount % 10 == 0){
            cameraCount = 0;
            cameraController.startImageStream((image) => ObjectDetector(image));
            update();
          }
        })
      );
      isCameraInitialized(true);
      update();
    }
    else{
      print("Permission Denied");
    }
  }
  initTFLite() async {
    await Tflite.loadModel
  }
  ObjectDetector(CameraImage image) async{
    var detector = await TfLite.runModelOnFrame(
      bytesList: image.planes.map((e){
        return e.bytes;
      }).toList(),
      asynch: true,
      imageHeight : image.height,
      imageWidth : image.width,
      imageMean : 127.5,
      imageStd : 127.5,
      numResults : 1,
      rotation : 90,
      threshold : 0.4,
    );
    if (detector != null){

    }
  }
}