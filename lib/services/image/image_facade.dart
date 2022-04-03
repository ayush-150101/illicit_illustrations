import 'dart:typed_data';


import '/services/image/image_transfer_facade.dart';

class ImageFacade {
  ImageTransferFacade _imageTransferFacade = ImageTransferFacade();

  static Future<void> loadModel() async {
    return ImageTransferFacade.loadModel();
  }

  static Future<Uint8List> loadStyleImage(String styleImagePath) async {
    return ImageTransferFacade.loadStyleImage(styleImagePath);
  }

  static Future<Uint8List?> transfer(Uint8List originData, Uint8List styleData) async {
    return ImageTransferFacade.transfer(originData, styleData);
  }
}