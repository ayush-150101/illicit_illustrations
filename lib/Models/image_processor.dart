import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as http_parser;
import 'package:illicit_illustrations/services/image/image_facade.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tflite/tflite.dart';


/// class for functions related to processing image based on tflite model in the assets directory

class ImageProcessor {

  /*/// Function to load tflite model from assets on to the tflite package
  static loadModel() async {
    //this function loads our model
    await Tflite.loadModel(
      model: 'assets/vangogh.tflite',
    );
  }

  /// Function to process image using the tflite model and return image in Unit8List format
  static Future<Uint8List> processImage(File image) async {
    /// calling function to load tflite model
    await loadModel();

    /// function to run Pix2Pix on image received in parameter of function
    var output = await Tflite.runPix2PixOnImage(
      path: image.path,
      imageMean: 127.5,
      imageStd: 127.5,
      asynch: true,
    );

    return output!;
  }*/

  static List<int> _selectedStyles = [];

  /// Function to run style transfer using input and style file and running it against an api
  static Future<Uint8List?> processImageUsingStyleTransfer(
      File input, File style) async {

    File contentFile = await FlutterNativeImage.compressImage(input.path,
        quality: 80,
        targetWidth: 680,
        targetHeight: 680);
    Uint8List contentImage = contentFile.readAsBytesSync();
    Uint8List styleImage = style.readAsBytesSync();
    await ImageFacade.loadModel();
    Uint8List? bytes = await ImageFacade.transfer(contentImage, styleImage) ;

    /*Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    String _proceessedImage = await ArtisticStyleTransfer.styleTransfer(styles: _selectedStyles, inputFilePath: input.path, outputFilePath: tempPath, quality: 100, styleFactor: 1.0, convertToGrey: false);*/


    /*http.MultipartRequest request = http.MultipartRequest(
        'POST', Uri.parse("https://api.deepai.org/api/fast-style-transfer"));
    Map<String, String> headers = {"api-key": "68ca325f-e621-4d00-8426-8787e1084ce7"};
    request.files.add(
      await http.MultipartFile.fromPath(
        'content',
        contentFile.path,
      ),
    );
    request.files.add(
      await http.MultipartFile.fromPath(
        'style',
        style.path,
      ),
    );
    request.headers.addAll(headers);
    http.StreamedResponse res = await request.send();
    var response = await http.Response.fromStream(res);
    var json = jsonDecode(response.body);
    //print("Status : ${json}");

    Uint8List bytes = (await NetworkAssetBundle(Uri.parse(json['output_url'])).load(json['output_url']))
        .buffer
        .asUint8List();*/




    return bytes;
  }
}
