import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:illicit_illustrations/controllers/image_controller.dart';
import 'package:illicit_illustrations/screens/home_screen.dart';
import 'package:illicit_illustrations/utilities/util.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:flutter_glow/flutter_glow.dart';


class ImageEditor extends StatefulWidget {
  /// variable to store File parameter passed from HomeScreen
  File image;
  ImageEditor({Key? key, required this.image}) : super(key: key);

  @override
  _ImageEditorState createState() => _ImageEditorState();
}

class _ImageEditorState extends State<ImageEditor> {
  /// variable to change state of page once image has finished processing
  bool imageProcessed = true;

  /// variable to store state of show more options
  bool showMoreOptions = false;

  /// variable to store focused index of ScrollSnapList widget
  int _focusedIndex = 0;

  /// scroll controller for ScrollSnapList widget
  ScrollController? _controller;

  /// List of assets for artistic style
  List<String> assets = [
    "",
  ];

  void getAssets() {
    for (int i = 0; i < 29; i++) {
      assets.add("assets/style$i.jpg");
    }
  }

  /// Function to toggle more options view
  void toggleOptions() async {
    setState(() {
      showMoreOptions = !showMoreOptions;
    });
  }

  /// Widget to return item for ScrollSnapList widget
  Widget _buildListItem(BuildContext context, int index) {
    //horizontal
    return Padding(
      padding: const EdgeInsets.all(8.0),

      /// Widget to shrink widget to 60% of original size when in unfocused position
      child: Transform.scale(
        scale: _focusedIndex == index ? 1 : 0.75,
        child: Container(
            height: 80,
            width: 80,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.purple,
                Colors.pink,
              ],
            ),),
            child: assets[index] == ""
                ?

                /// Widget for the initial or no-filter option
                Padding(
                    padding: _focusedIndex == index
                        ? const EdgeInsets.all(5.0)
                        : const EdgeInsets.all(0.0),
                    child: Container(
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.black),
                      child: Padding(
                        padding: _focusedIndex == index
                            ? const EdgeInsets.all(6.0)
                            : const EdgeInsets.all(0.0),
                        child: Container(
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                        ),
                      ),
                    ),
                  )
                :

                /// Widget for the other filters
                Padding(
                    padding: _focusedIndex == index
                        ? const EdgeInsets.all(5.0)
                        : const EdgeInsets.all(0.0),
                    child: CircleAvatar(
                      backgroundImage: AssetImage(
                        assets[index],
                      ),
                      radius: 20,
                    ),
                  )),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getAssets();
  }

  @override
  Widget build(BuildContext context) {
    final imageController = Get.put(ImageController(content: widget.image));
    return GetX<ImageController>(builder: (controller) {
      //controller.onInit();
        return WillPopScope(
          onWillPop: () async{ Get.delete<ImageController>();Get.back();return true;},
          child: Scaffold(
            backgroundColor: Colors.black,
            body: Stack(children: [
                Stack(
                  children: [
                    Padding(
                        padding: EdgeInsets.fromLTRB(
                            0, MediaQuery.of(context).size.height * 0.1, 0, 0),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              bottom: MediaQuery.of(context).size.height * 0.28,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                                child: SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.6,
                                  width: MediaQuery.of(context).size.width * 0.95,
                                  child: controller.imageProcessed.value
                                      ? Stack(
                                          children: [
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.75,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.95,
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                  child:

                                                      /// Displaying image returned by tflite model
                                                      Image.memory(
                                                    controller.image,
                                                    fit: BoxFit.fill,
                                                  )),
                                            ),

                                            /// Widget to toggle more options screen on top of the image
                                            InkWell(
                                              onTap: () => toggleOptions(),
                                              child: Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.75,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.95,
                                                color: showMoreOptions
                                                    ? Colors.black.withOpacity(0.6)
                                                    : Colors.transparent,
                                                child: showMoreOptions
                                                    ? Center(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            /// Widget for save image icon
                                                            InkWell(
                                                              onTap: () async {
                                                                /// function to save processed image to gallery
                                                                ImageGallerySaver
                                                                    .saveImage(
                                                                        controller
                                                                            .image,
                                                                        quality:
                                                                            100);

                                                                ScaffoldMessenger
                                                                        .of(context)
                                                                    .showSnackBar(
                                                                        const SnackBar(
                                                                  content: Text(
                                                                      'Image Saved To Gallery'),
                                                                  duration:
                                                                      Duration(
                                                                          seconds:
                                                                              1),
                                                                ));
                                                              },
                                                              child: Container(
                                                                height: 60,
                                                                width: 60,
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.6)),
                                                                child: const Icon(
                                                                  Icons.save_alt,
                                                                  color:
                                                                      Colors.white,
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
                                                                /// function to share processed image
                                                                Utilities
                                                                    .shareImage(
                                                                        controller
                                                                            .image);
                                                              },
                                                              child: Container(
                                                                height: 60,
                                                                width: 60,
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.6)),
                                                                child: const Icon(
                                                                  Icons.share,
                                                                  color:
                                                                      Colors.white,
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
                                        )
                                      : const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                ),
                              ),
                            ),
                            Positioned(
                              //alignment: Alignment.bottomCenter,
                              bottom: 10,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 20, 20, 10),
                                child: Container(
                                  height: 90,
                                  width: MediaQuery.of(context).size.width,
                                  child: ScrollSnapList(
                                    listController: _controller,
                                    onItemFocus: (pos) {

                                      setState(() {
                                        _focusedIndex = pos;
                                      });
                                      //controller.changeState(_focusedIndex - 1);
                                      print('Index: $_focusedIndex');
                                      //controller.changeState(pos - 1);
                                    },
                                    itemSize: 96,
                                    itemBuilder: _buildListItem,
                                    itemCount: assets.length,
                                    //reverse: true,
                                    curve: Curves.ease,
                                  ),
                                ),
                              ),
                            ),

                            Positioned(
                              bottom: 130,
                              child: InkWell(
                                onTap: () {
                                  if(_focusedIndex<=27) {
                                    controller.changeState(_focusedIndex,true);
                                  }else{
                                    controller.changeState(_focusedIndex,false);
                                  }
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topRight,
                                        end: Alignment.bottomLeft,
                                        colors: [
                                          Color(0xFF611E8E),
                                          Color(0xFFF12FCA),
                                        ],
                                      ),
                                    borderRadius: BorderRadius.all(Radius.circular(10))

                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: GlowText(
                                      'APPLY',
                                      style: TextStyle(fontSize: 20, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                    controller.imageProcessing.value?Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.black.withOpacity(0.6),
                      child: Image.asset('assets/loading_2.png'),
                    ):Container(),



                  ],
                )
              ])
            ),
        );});
  }
}
