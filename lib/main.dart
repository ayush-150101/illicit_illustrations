import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:illicit_illustrations/screens/camera_screen.dart';
import 'package:illicit_illustrations/screens/splash_screen.dart';
import 'package:illicit_illustrations/test/test.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      home: SplashScreen(),
      //TestView(content: 'test_image.jpg',)
      //CameraScreen(),
    );
  }
}

