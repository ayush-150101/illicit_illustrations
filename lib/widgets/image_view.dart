import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:illicit_illustrations/Models/image_processor.dart';
import 'package:illicit_illustrations/Utilities/util.dart';
import 'dart:io';
import 'package:illicit_illustrations/Utilities/util.dart';

import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

class ImageView extends StatefulWidget {
  File content;
  String? stylePath;

  ImageView({Key? key, required this.content, this.stylePath})
      : super(key: key);

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  Uint8List? _output;
  bool showMoreOptions = false;
  bool imageProcessed = false;
  bool styleProvided = false;



  /// Function to call processImage function of class Image Processor and return precessed image in Uint8List format
  void initialise() async {
    File style = await Utilities.getImageFileFromAssets(widget.stylePath!);
    _output = await ImageProcessor.processImageUsingStyleTransfer(
        widget.content, style);
    setState(() {
      imageProcessed = true;
    });
  }

  /// Function to toggle more options view
  void toggleOptions() async {
    setState(() {
      showMoreOptions = !showMoreOptions;
    });
  }

  @override
  void initState() {
    super.initState();
    if(widget.stylePath != null) {
      setState(() {
        styleProvided = true;
      });
    }

    else {
      setState(() {
      styleProvided =false;
    });
    }


    styleProvided
        ? initialise()
        : setState(() {
            imageProcessed = true;
          });
  }

  Widget styleImage(){
    return imageProcessed?
    /// Displaying image returned by tflite model
    Image.memory(
      _output!,
      fit: BoxFit.fill,
    ):const Center(child: CircularProgressIndicator(),);
  }

  @override
  Widget build(BuildContext context) {
    print(widget.stylePath);
    if(widget.stylePath != null) {
      setState(() {
        styleProvided = true;
      });
    }

    else {
      setState(() {
        styleProvided =false;
      });
    }


    styleProvided
        ? initialise()
        : setState(() {
      imageProcessed = true;
    });
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          width: MediaQuery.of(context).size.width * 0.95,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: styleProvided
                ?
                styleImage()
                :

                /// Displaying initial image
                Image.file(
                    widget.content,
                    fit: BoxFit.fill,
                  )
          ),
        ),

        /// Widget to toggle more options screen on top of the image
        InkWell(
          onTap: () => toggleOptions(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.75,
            width: MediaQuery.of(context).size.width * 0.95,
            color: showMoreOptions
                ? Colors.black.withOpacity(0.6)
                : Colors.transparent,
            child: showMoreOptions
                ? Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        /// Widget for save image icon
                        InkWell(
                          onTap: () async {
                            !styleProvided
                                ?

                                /// function to save initial image to gallery
                                ImageGallerySaver.saveFile(widget.content.path)
                                :

                                /// function to save processed image to gallery
                                ImageGallerySaver.saveImage(_output!,
                                    quality: 100);

                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Image Saved To Gallery'),
                              duration: Duration(seconds: 1),
                            ));
                          },
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withOpacity(0.6)),
                            child: const Icon(
                              Icons.save_alt,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),

                        /// Widget for share image icon
                        InkWell(
                          onTap: () async {
                            widget.stylePath == null
                                ?

                                /// function to share initial image
                                Share.shareFiles([widget.content.path])
                                :

                                /// function to share processed image
                                Utilities.shareImage(_output!);
                          },
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withOpacity(0.6)),
                            child: const Icon(
                              Icons.share,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                : Container(),
          ),
        ),
      ],
    );
  }
}
