import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:today/controller/video_controller.dart';
// ignore: depend_on_referenced_packages
import 'package:video_box/video_box.dart';

class OneVideoCtrl extends StatefulWidget {
  const OneVideoCtrl({Key? key}) : super(key: key);

  @override
  createState() => _OneVideoCtrlState();
}

class _OneVideoCtrlState extends State<OneVideoCtrl> {
  var loading = false;
  VideoController? vc, vc1;
  ScrollController controller = ScrollController();
  final VideosController _controller = Get.put(VideosController());
  @override
  void initState() {
    setState(() {
      loading = true;
      log(loading.toString());
    });

    // var vid = _controller.getAllVideos();
    // var lst = vid.toList();
    setState(() {
      for (var e = 0; e < _controller.videos.length; e++) {
        log("videos: ${_controller.videos[e].vid!}");
        vc = VideoController(
          source: VideoPlayerController.network(_controller.videos[e].vid!),
          autoplay: false,
        )
          ..initialize().then((e) {
            // ignore: avoid_print
            print(e);
            // if (e != null) {
            //   print('[video box init] error: ' + e.message);
            // } else {
            //   print('[video box init] success');
            // }
          })
          ..addListener(() {
            if (vc!.videoCtrl.value.isBuffering) {
              // ignore: avoid_print
              print('==============================');
              // ignore: avoid_print
              print('isBuffering');
              // ignore: avoid_print
              print('==============================');
            }
          });
      }
      loading = false;
    });
    // setState(() {
    //   loading = false;
    // });
    super.initState();
  }

  void _init() async {
    /*  vc1 = VideoController(
      source: VideoPlayerController.network(_controller.videos[1].vid!),
      autoplay: true,
    )
      ..initialize().then((e) {
        // ignore: avoid_print
        print(e);
        // if (e != null) {
        //   print('[video box init] error: ' + e.message);
        // } else {
        //   print('[video box init] success');
        // }
      })
      ..addListener(() {
        if (vc.videoCtrl.value.isBuffering) {
          // ignore: avoid_print
          print('==============================');
          // ignore: avoid_print
          print('isBuffering');
          // ignore: avoid_print
          print('==============================');
        }
      });*/
  }

  @override
  void dispose() {
    loading = false;
    vc!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log(" build " + loading.toString());
    return Scaffold(
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                controller: controller,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: VideoBox(
                      controller: vc!,
                      children: <Widget>[
                        VideoBar(vc: vc!),
                        Align(
                          alignment: const Alignment(0.5, 0),
                          child: IconButton(
                            iconSize: VideoBox.centerIconSize,
                            disabledColor: Colors.white60,
                            icon: const Icon(Icons.skip_next),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    children: <Widget>[
                      ElevatedButton(
                        child: const Text('play'),
                        onPressed: () {
                          vc!.play();
                        },
                      ),
                      ElevatedButton(
                        child: const Text('pause'),
                        onPressed: () {
                          vc!.pause();
                        },
                      ),
                      ElevatedButton(
                        child: const Text('full screen'),
                        onPressed: () => vc!.onFullScreenSwitch(context),
                      ),
                      ElevatedButton(
                        child: const Text('print'),
                        onPressed: () {
                          // ignore: avoid_print
                          print(vc);
                          // ignore: avoid_print
                          print(vc!.value);
                        },
                      ),
                    ],
                  ),
                  // AspectRatio(
                  //   aspectRatio: 16 / 9,
                  //   child: VideoBox(
                  //     controller: vc1,
                  //     children: <Widget>[
                  //       VideoBar(vc: vc1),
                  //       Align(
                  //         alignment: const Alignment(0.5, 0),
                  //         child: IconButton(
                  //           iconSize: VideoBox.centerIconSize,
                  //           disabledColor: Colors.white60,
                  //           icon: const Icon(Icons.skip_next),
                  //           onPressed: () {},
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // Wrap(
                  //   alignment: WrapAlignment.spaceBetween,
                  //   children: <Widget>[
                  //     ElevatedButton(
                  //       child: const Text('play'),
                  //       onPressed: () {
                  //         vc1.play();
                  //       },
                  //     ),
                  //     ElevatedButton(
                  //       child: const Text('pause'),
                  //       onPressed: () {
                  //         vc1.pause();
                  //       },
                  //     ),
                  //     ElevatedButton(
                  //       child: const Text('full screen'),
                  //       onPressed: () => vc1.onFullScreenSwitch(context),
                  //     ),
                  //     ElevatedButton(
                  //       child: const Text('print'),
                  //       onPressed: () {
                  //         // ignore: avoid_print
                  //         print(vc1);
                  //         // ignore: avoid_print
                  //         print(vc1.value);
                  //       },
                  //     ),
                  //   ],
                  // ),
                ],
              ));
    // : Center(child: Text("no Video Founded")));
  }
}

class VideoBar extends StatelessWidget {
  final VideoController vc;
  final List<double> speeds;

  const VideoBar({
    Key? key,
    required this.vc,
    this.speeds = const [0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0],
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      top: 0,
      right: 0,
      child: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('test'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.slow_motion_video),
                        title: const Text('play speed'),
                        onTap: () {
                          showModalBottomSheet<double>(
                            context: context,
                            builder: (context) {
                              return ListView(
                                children: speeds
                                    .map((e) => ListTile(
                                          title: Text(e.toString()),
                                          onTap: () =>
                                              Navigator.of(context).pop(e),
                                        ))
                                    .toList(),
                              );
                            },
                          ).then((value) {
                            if (value != null) vc.setPlaybackSpeed(value);
                            Navigator.of(context).pop();
                          });
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
