/*import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:illicit_illustrations/controllers/image_controller.dart';

class TestView extends StatelessWidget {
  String content;
  TestView({Key? key, required this.content}) : super(key: key);

  int _focusedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final imageController = Get.put(ImageController(contentPath: content));
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: GetX<ImageController>(builder: (controller) {
              print('${controller.styleIndex}');
              return Column(children: [
                controller.imageProcessed.value
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height * 0.75,
                        width: MediaQuery.of(context).size.width * 0.95,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child:

                                /// Displaying image returned by tflite model
                                Image.memory(
                              controller.image,
                              fit: BoxFit.fill,
                            )),
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
                ElevatedButton(
                    onPressed: ()=>controller.changeState(),
                    child: const Text('CHANGE'))
              ]);
            }),
          )
        ],
      ),
    );
  }
}*/
