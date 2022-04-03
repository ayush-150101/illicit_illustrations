import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:io';

import 'package:illicit_illustrations/screens/image_editor_screen.dart';
import 'package:path_provider/path_provider.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {

  /// variable to store image captured by camera package
  File? image;

  /// variable to store state of camera
  bool cameraLoaded = false;

  /// variable to store state of image captured
  /// false state shows camera preview
  /// true state shows image captured
  bool showPicture = false;

  /// variable to store camera index
  /// 0 is rear/main camera
  /// 1 is front-facing/secondary camera
  int _cameraIndex = 0;

  /// List to store descriptions of available cameras
  List<CameraDescription>? _cameras;

  /// camera controller
  CameraController? _controller;


  /// function to load all the available cameras and the initialise the camera controller
  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(
      _cameras![_cameraIndex],
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );
    _controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        cameraLoaded = true;
      });
    });
  }

  /// function to capture image
  void takePicture() async {
    XFile temp = await _controller!.takePicture();
    image = File(temp.path);

    setState(() {
      showPicture = true;
    });
  }

  @override
  void initState() {
    _initCamera();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.75;
    final width = MediaQuery.of(context).size.width * 0.95;
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(children: [
          Padding(
              padding: EdgeInsets.fromLTRB(
                  0, MediaQuery.of(context).size.height * 0.1, 0, 0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    bottom: MediaQuery.of(context).size.height * 0.21,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.61,
                        width: MediaQuery.of(context).size.width,
                        child: cameraLoaded
                            ? showPicture
                                ? ClipRRect(
                                    //borderRadius: BorderRadius.circular(40),
                                    child: Image.file(
                                      image!,
                                      fit: BoxFit.cover,
                                    ))
                                : Transform.scale(
                                    scale: 1.23,
                                    child: Center(
                                      child: ClipRRect(
                                        //borderRadius: BorderRadius.circular(40),
                                        child: AspectRatio(
                                          aspectRatio: 1,
                                          child:
                                              CameraPreview(_controller!),
                                        ),
                                      ),
                                    ),
                                  )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SizedBox(
                          height: 90,
                          //width: 200,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    cameraLoaded = false;
                                  });

                                  if (_cameraIndex == 0) {
                                    _cameraIndex = 1;
                                  } else {
                                    _cameraIndex = 0;
                                  }

                                  _controller = CameraController(
                                    _cameras![_cameraIndex],
                                    ResolutionPreset.medium,
                                    imageFormatGroup: ImageFormatGroup.yuv420,
                                  );
                                  _controller!.initialize().then((_) {
                                    if (!mounted) {
                                      return;
                                    }
                                    setState(() {
                                      cameraLoaded = true;
                                    });
                                  });
                                },
                                child: Container(
                                  height: 50,
                                  decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.flip_camera_android_outlined,
                                    size: 55.0,
                                    color: showPicture?Colors.transparent:Colors.pink,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () async{
                                  if (showPicture) {
                                    _controller!.dispose();
                                    Uint8List imageBytes = await FlutterImageCompress.compressWithList(
                                        await image!.readAsBytes(),
                                        quality: 100,
                                  rotate: 0);
                                    final tempDir = await getTemporaryDirectory();
                                    DateTime now = DateTime.now();
                                    File file = await File('${tempDir.path}/${now.toString()}.png').create();
                                    file.writeAsBytes(imageBytes);
                                    Navigator.pushReplacement(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder:
                                            (context, animation1, animation2) =>
                                                ImageEditor(image: file),
                                        transitionDuration: Duration.zero,
                                      ),
                                    );
                                  } else
                                    takePicture();
                                },
                                child: Container(
                                  height: 50,
                                  decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    showPicture == false
                                        ? Icons.camera
                                        : Icons.check,
                                    size: 55.0,
                                    color: Colors.pink,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    showPicture = false;
                                  });
                                },
                                child: Container(
                                  height: 50,
                                  decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.refresh,
                                    size: 55.0,
                                    color: showPicture
                                        ? Colors.pink
                                        : Colors.transparent,
                                  ),
                                ),
                              )
                            ],
                          )),
                    ),
                  ),
                ],
              ))
        ]));
  }
}
