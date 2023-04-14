import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:video_thumbnail/video_thumbnail.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DemoHome(),
    );
  }
}

class ThumbnailRequest {
  final String? video;
  final String? thumbnailPath;
  final ImageFormat? imageFormat;
  final int? maxHeight;
  final int? maxWidth;
  final int? timeMs;
  final int? quality;

  const ThumbnailRequest(
      {this.video,
      this.thumbnailPath,
      this.imageFormat,
      this.maxHeight,
      this.maxWidth,
      this.timeMs,
      this.quality});
}

class ThumbnailResult {
  final Image? image;
  final int? dataSize;
  final int? height;
  final int? width;
  const ThumbnailResult({this.image, this.dataSize, this.height, this.width});
}

Future<List<ThumbnailResult>> genThumbnail(List<ThumbnailRequest> r) async {
  //WidgetsFlutterBinding.ensureInitialized();
  Uint8List? bytes;
  final Completer<List<ThumbnailResult>> completer = Completer();
  for (var req in r) {
    if (req.thumbnailPath != null) {
      log("video: ${req.video!}");
      log("image Format: ${req.imageFormat!}");
      log("maxHeight: ${req.maxHeight!}");
      log("maxWidth: ${req.maxWidth!}");
      log("timesMS: ${req.timeMs!}");
      log("quality: ${req.quality!}");

      final thumbnailPath = await VideoThumbnail.thumbnailFile(
          video: req.video!,
          headers: {
            "USERHEADER1": "user defined header1",
            "USERHEADER2": "user defined header2",
          },
          thumbnailPath: req.thumbnailPath,
          imageFormat: req.imageFormat!,
          maxHeight: req.maxHeight!,
          maxWidth: req.maxWidth!,
          timeMs: req.timeMs!,
          quality: req.quality!);

      print("thumbnail file is located: $thumbnailPath");

      final file = File(thumbnailPath!);
      bytes = file.readAsBytesSync();
    } else {
      log("video: ${req.video!}");
      log("image Format: ${req.imageFormat!}");
      log("maxHeight: ${req.maxHeight!}");
      log("maxWidth: ${req.maxWidth!}");
      log("timesMS: ${req.timeMs!}");
      log("quality: ${req.quality!}");

      bytes = (await VideoThumbnail.thumbnailData(
          video: req.video!,
          headers: {
            "USERHEADER1": "user defined header1",
            "USERHEADER2": "user defined header2",
          },
          imageFormat: req.imageFormat!,
          maxHeight: req.maxHeight!,
          maxWidth: req.maxWidth!,
          timeMs: req.timeMs!,
          quality: req.quality!))!;
    }
  // }

  int _imageDataSize = bytes.length;
  print("image size: $_imageDataSize");
  
  final _image = Image.memory(bytes);
  _image.image
      .resolve(ImageConfiguration())
      .addListener(ImageStreamListener((ImageInfo info, bool _) {
      var res = <ThumbnailResult>[];
      res.add(ThumbnailResult(
      image: _image,
      dataSize: _imageDataSize,
      height: info.image.height,
      width: info.image.width,
    ));
    completer.complete(res);
  }));
}
  return completer.future;
}

class GenThumbnailImage extends StatefulWidget {
  final List<ThumbnailRequest>? thumbnailRequest;

  const GenThumbnailImage({Key? key, this.thumbnailRequest}) : super(key: key);

  @override
  _GenThumbnailImageState createState() => _GenThumbnailImageState();
}

class _GenThumbnailImageState extends State<GenThumbnailImage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ThumbnailResult>>(
      future: genThumbnail(widget.thumbnailRequest!),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final _image = snapshot.data.image;
          final _width = snapshot.data.width;
          final _height = snapshot.data.height;
          final _dataSize = snapshot.data.dataSize;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Center(
              //   child: Text(
              //       "Image ${widget.thumbnailRequest!.thumbnailPath == null ? 'data size' : 'file size'}: $_dataSize, width:$_width, height:$_height"),
              // ),
              Container(
                color: Colors.grey,
                height: 1.0,
              ),
              _image,
            ],
          );
        } else if (snapshot.hasError) {
          return Container(
            padding: EdgeInsets.all(8.0),
            color: Colors.red,
            child: Text(
              "Error:\n${snapshot.error.toString()}",
            ),
          );
        } else {
          return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Text(
                //     "Generating the thumbnail for: ${widget.thumbnailRequest!.video}..."),
                SizedBox(
                  height: 10.0,
                ),
                CircularProgressIndicator(),
              ]);
        }
      },
    );
  }
}

class ImageInFile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class DemoHome extends StatefulWidget {
  @override
  _DemoHomeState createState() => _DemoHomeState();
}

class _DemoHomeState extends State<DemoHome> {
  final _editNode = FocusNode();
  final _video = TextEditingController(
      text:
          "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4");
  ImageFormat _format = ImageFormat.JPEG;
  int _quality = 50;
  int _sizeH = 0;
  int _sizeW = 0;
  int _timeMs = 0;

  GenThumbnailImage? _futreImage;

  String? _tempDir;

  @override
  void initState() {
    super.initState();
    getTemporaryDirectory().then((d) => _tempDir = d.path);
  }

 List<ThumbnailRequest> thum() {
    var thumbnailRequest = <ThumbnailRequest>[];
    for (int i = 0; i < 5; i++) {
      thumbnailRequest.add(ThumbnailRequest(
          video:
              "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
          thumbnailPath: _tempDir,
          imageFormat: ImageFormat.JPEG,
          maxHeight: 0,
          maxWidth: 0,
          timeMs: 0,
          quality: 0));
    }
    return thumbnailRequest;
  }

  @override
  Widget build(BuildContext context) {
    final _settings = <Widget>[
      Slider(
        value: _sizeH * 1.0,
        onChanged: (v) => setState(() {
          _editNode.unfocus();
          _sizeH = v.toInt();
        }),
        max: 256.0,
        divisions: 256,
        label: "$_sizeH",
      ),
      Center(
        child: (_sizeH == 0)
            ? const Text(
                "Original of the video's height or scaled by the source aspect ratio")
            : Text("Max height: $_sizeH(px)"),
      ),
      Slider(
        value: _sizeW * 1.0,
        onChanged: (v) => setState(() {
          _editNode.unfocus();
          _sizeW = v.toInt();
        }),
        max: 256.0,
        divisions: 256,
        label: "$_sizeW",
      ),
      Center(
        child: (_sizeW == 0)
            ? const Text(
                "Original of the video's width or scaled by source aspect ratio")
            : Text("Max width: $_sizeW(px)"),
      ),
      Slider(
        value: _timeMs * 1.0,
        onChanged: (v) => setState(() {
          _editNode.unfocus();
          _timeMs = v.toInt();
        }),
        max: 10.0 * 1000,
        divisions: 1000,
        label: "$_timeMs",
      ),
      Center(
        child: (_timeMs == 0)
            ? const Text("The beginning of the video")
            : Text("The closest frame at $_timeMs(ms) of the video"),
      ),
      Slider(
        value: _quality * 1.0,
        onChanged: (v) => setState(() {
          _editNode.unfocus();
          _quality = v.toInt();
        }),
        max: 100.0,
        divisions: 100,
        label: "$_quality",
      ),
      Center(child: Text("Quality: $_quality")),
      Padding(
        padding: const EdgeInsets.fromLTRB(2.0, 10.0, 2.0, 8.0),
        child: InputDecorator(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            filled: true,
            isDense: true,
            labelText: "Thumbnail Format",
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Radio<ImageFormat>(
                      groupValue: _format,
                      value: ImageFormat.JPEG,
                      onChanged: (v) => setState(() {
                        _format = v!;
                        _editNode.unfocus();
                      }),
                    ),
                    const Text("JPEG"),
                  ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Radio<ImageFormat>(
                      groupValue: _format,
                      value: ImageFormat.PNG,
                      onChanged: (v) => setState(() {
                        _format = v!;
                        _editNode.unfocus();
                      }),
                    ),
                    const Text("PNG"),
                  ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Radio<ImageFormat>(
                      groupValue: _format,
                      value: ImageFormat.WEBP,
                      onChanged: (v) => setState(() {
                        _format = v!;
                        _editNode.unfocus();
                      }),
                    ),
                    const Text("WebP"),
                  ]),
            ],
          ),
        ),
      )
    ];

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Thumbnail Plugin example'),
      // ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FutureBuilder<List<ThumbnailResult>>(
            future: genThumbnail(thum()),
            builder: (BuildContext context, AsyncSnapshot snapshot) {  
                if (snapshot.hasData) {
                  for (var element in snapshot.data) {
                  final _image = element.image;
                  final _width = element.width;
                  final _height = element.height;
                  final _dataSize = element.dataSize;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // Center(
                      //   child: Text(
                      //       "Image ${widget.thumbnailRequest!.thumbnailPath == null ? 'data size' : 'file size'}: $_dataSize, width:$_width, height:$_height"),
                      // ),
                      Container(
                        color: Colors.grey,
                        height: 1.0,
                      ),
                      _image,
                    ],
                  );
                }} 
                if (snapshot.hasError) {
                  return Container(
                    padding: EdgeInsets.all(8.0),
                    color: Colors.red,
                    child: Text(
                      "Error:\n${snapshot.error.toString()}",
                    ),
                  );
                } else {
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        // Text(
                        //     "Generating the thumbnail for: ${thumbnailRequest.video}..."),
                        SizedBox(
                          height: 10.0,
                        ),
                        CircularProgressIndicator(),
                      ]);
                }
              } 
            // },
          ),
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(2.0, 10.0, 2.0, 8.0),
          //   child: TextField(
          //     decoration: InputDecoration(
          //       border: OutlineInputBorder(),
          //       filled: true,
          //       isDense: true,
          //       labelText: "Video URI",
          //     ),
          //     maxLines: null,
          //     controller: _video,
          //     focusNode: _editNode,
          //     keyboardType: TextInputType.url,
          //     textInputAction: TextInputAction.done,
          //     onEditingComplete: () {
          //       _editNode.unfocus();
          //     },
          //   ),
          // ),
          // for (var i in _settings) i,
          Expanded(
            child: Container(
              color: Colors.grey[300],
              child: Scrollbar(
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    (_futreImage != null) ? _futreImage! : SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      // drawer: Drawer(
      //   child: Column(
      //     children: <Widget>[
      //       AppBar(
      //         title: const Text("Settings"),
      //         actions: <Widget>[
      //           IconButton(
      //             icon: Icon(Icons.close),
      //             onPressed: () => Navigator.pop(context),
      //           )
      //         ],
      //       ),
      //       // for (var i in _settings) i,
      //     ],
      //   ),
      // ),
      // floatingActionButton: Row(
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   mainAxisSize: MainAxisSize.min,
      //   children: <Widget>[
      //     FloatingActionButton(
      //       onPressed: () async {
      //         var video = await FilesystemPicker.open(
      //             context: context,
      //             rootDirectory: Directory("storage/emulated/0"));
      //         setState(() {
      //           _video.text = video!;
      //         });
      //       },
      //       child: Icon(Icons.videocam),
      //       tooltip: "Capture a video",
      //     ),
      //     const SizedBox(
      //       width: 5.0,
      //     ),
      //     FloatingActionButton(
      //       onPressed: () async {
      //         var video = await FilesystemPicker.open(
      //             context: context,
      //             rootDirectory: Directory("storage/emulated/0"));
      //         setState(() {
      //           _video.text = video!;
      //         });
      //       },
      //       child: Icon(Icons.local_movies),
      //       tooltip: "Pick a video",
      //     ),
      //     const SizedBox(
      //       width: 20.0,
      //     ),
      //     FloatingActionButton(
      //       tooltip: "Generate a data of thumbnail",
      //       onPressed: () async {
      //         setState(() {
      //           _futreImage = GenThumbnailImage(
      //               thumbnailRequest: ThumbnailRequest(
      //                   video: _video.text,
      //                   thumbnailPath: null,
      //                   imageFormat: _format,
      //                   maxHeight: _sizeH,
      //                   maxWidth: _sizeW,
      //                   timeMs: _timeMs,
      //                   quality: _quality));
      //         });
      //       },
      //       child: const Text("Data"),
      //     ),
      //     const SizedBox(
      //       width: 5.0,
      //     ),
      //     FloatingActionButton(
      //       tooltip: "Generate a file of thumbnail",
      //       onPressed: () async {
      //         setState(() {
      //           _futreImage = GenThumbnailImage(
      //               thumbnailRequest: ThumbnailRequest(
      //                   video: _video.text,
      //                   thumbnailPath: _tempDir,
      //                   imageFormat: _format,
      //                   maxHeight: _sizeH,
      //                   maxWidth: _sizeW,
      //                   timeMs: _timeMs,
      //                   quality: _quality));
      //         });
      //       },
      //       child: const Text("File"),
      //     ),
      //   ],
      // )
    );
  }
}
