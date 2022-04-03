import 'dart:typed_data';
import 'dart:io';
import 'package:illicit_illustrations/Models/image_processor.dart';

import 'package:get/state_manager.dart';
import 'package:illicit_illustrations/Utilities/util.dart';
import 'package:tflite/tflite.dart';

class ImageController extends GetxController {
  dynamic image = null.obs;
  var imageProcessed = false.obs;
  var imageProcessing = false.obs;

  Map<int, Uint8List> processedImages = {};

  //String contentPath ;
  File content;
  int styleIndex = -1;

  List<String> styles = ["monet.jpeg"];

  ImageController({required this.content});

  void getAssets(){

    for(int i = 0;i<29;i++) {
      styles.add("style$i.jpg");
    }

  }

  @override
  void onInit() {
    super.onInit();
    print('onInitCalled');
    getAssets();
    processImage();
  }

  Future<void> processImage() async {
    //imageProcessed.value = false;
    //final content = await Utilities.getImageFileFromAssets(contentPath);

    imageProcessing.value = true;

    await Future.delayed(const Duration(milliseconds: 60));

    if (styleIndex == -1) {
      final bytes = await content.readAsBytes(); // Uint8List
      image = bytes; // ByteData

    } else {
      if (processedImages[styleIndex] != null) {
        image = processedImages[styleIndex];
      } else {
        File style = await Utilities.getImageFileFromAssets(styles[styleIndex]);
        image =
            await ImageProcessor.processImageUsingStyleTransfer(content, style);
        processedImages[styleIndex] = image;
      }
    }

    imageProcessing.value = false;
    imageProcessed.value = true;
  }

  /// Function to load tflite model from assets on to the tflite package
  loadModel(String modelName) async {
    //this function loads our model
    await Tflite.loadModel(
      model: 'assets/$modelName.tflite',
    );
  }

  Future<void> changeState(int index,bool applyStyleTransfer) async {
    //imageProcessed.value = false;
    imageProcessing.value = true;

    styleIndex = index;

    //imageProcessed.value = false;
    //final content = await Utilities.getImageFileFromAssets(contentPath);

       if(applyStyleTransfer) {
      if (styleIndex == -1) {
        final bytes = await content.readAsBytes(); // Uint8List
        image = bytes; // ByteData
      } else {
        if (processedImages[styleIndex] != null) {
          image = processedImages[styleIndex];
        } else {
          File style =
              await Utilities.getImageFileFromAssets(styles[styleIndex]);
          image = await ImageProcessor.processImageUsingStyleTransfer(
              content, style);
          processedImages[styleIndex] = image;
        }
      }
    }else{
         /// calling function to load tflite model
         await loadModel("style${styleIndex-1}");

         /// function to run Pix2Pix on image received in parameter of function
         image = await Tflite.runPix2PixOnImage(
           path: content.path,
           imageMean: 127.5,
           imageStd: 127.5,
           asynch: true,
         );
       }

    imageProcessing.value = false;
    imageProcessed.value = true;
  }
}
