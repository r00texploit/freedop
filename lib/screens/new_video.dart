import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:today/controller/video_controller.dart';
import 'package:video_player/video_player.dart';

class VideoPlayersList extends StatelessWidget {
  const VideoPlayersList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cont = Get.put(VideosController());
    var paths = cont.videos.toList();
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: Column(children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: paths.length,
            itemBuilder: (BuildContext context, int index) {
              log("message:${paths[index].vid}");
              return VideoPlay(
                pathh: paths[index].vid,
              );
            }, gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          ),
        ]),
      ),
    );
  }
}

class VideoPlay extends StatefulWidget {
  String? pathh;

  @override
  _VideoPlayState createState() => _VideoPlayState();

  VideoPlay({
    Key? key,
    this.pathh, // Video from assets folder
  }) : super(key: key);
}

class _VideoPlayState extends State<VideoPlay> {
  ValueNotifier<VideoPlayerValue?> currentPosition = ValueNotifier(null);
  VideoPlayerController? controller;
  late Future<void> futureController;

  initVideo() {
    controller = VideoPlayerController.network(widget.pathh!);

    futureController = controller!.initialize();
  }

  @override
  void initState() {
    initVideo();
    controller!.addListener(() {
      if (controller!.value.isInitialized) {
        currentPosition.value = controller!.value;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureController,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          return Hero(
            tag: "${controller!.dataSource}",
            child: Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10,left: 10,right: 10),
              child: SizedBox(
                height: controller!.value.size.shortestSide,
                width: double.infinity,
                child: AspectRatio(
                    aspectRatio: controller!.value.aspectRatio,
                    child: Stack(children: [
                      Positioned.fill(
                          child: Container(
                              foregroundDecoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      Colors.black.withOpacity(.7),
                                      Colors.transparent
                                    ],
                                    stops: [
                                      0,
                                      .3
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter),
                              ),
                              child: VideoPlayer(controller!))),
                      Positioned.fill(
                        child: Column(
                          children: [
                            Expanded(
                              flex: 8,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: GestureDetector(
                                      onDoubleTap: () async {
                                        Duration? position =
                                            await controller!.position;
                                        setState(() {
                                          controller!.seekTo(Duration(
                                              seconds: position!.inSeconds - 10));
                                        });
                                      },
                                      child: const Icon(
                                        Icons.fast_rewind_rounded,
                                        color: Colors.black,
                                        size: 40,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      flex: 4,
                                      child: IconButton(
                                        icon: Icon(
                                          controller!.value.isPlaying
                                              ? Icons.pause
                                              : Icons.play_arrow,
                                          color: Colors.black,
                                          size: 40,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            if (controller!.value.isPlaying) {
                                              controller!.pause();
                                            } else {
                                              controller!.play();
                                            }
                                          });
                                        },
                                      )),
                                  Expanded(
                                    flex: 3,
                                    child: GestureDetector(
                                      onDoubleTap: () async {
                                        Duration? position =
                                            await controller!.position;
                                        setState(() {
                                          controller!.seekTo(Duration(
                                              seconds: position!.inSeconds + 10));
                                        });
                                      },
                                      child: const Icon(
                                        Icons.fast_forward_rounded,
                                        color: Colors.black,
                                        size: 40,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                                flex: 2,
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: ValueListenableBuilder(
                                      valueListenable: currentPosition,
                                      builder: (context,
                                          VideoPlayerValue? videoPlayerValue, w) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          child: Row(
                                            children: [
                                              Text(
                                                videoPlayerValue!.position
                                                    .toString()
                                                    .substring(
                                                        videoPlayerValue.position
                                                                .toString()
                                                                .indexOf(':') +
                                                            1,
                                                        videoPlayerValue.position
                                                            .toString()
                                                            .indexOf('.')),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 22),
                                              ),
                                              Spacer(),
                                              Text(
                                                videoPlayerValue.duration
                                                    .toString()
                                                    .substring(
                                                        videoPlayerValue.duration
                                                                .toString()
                                                                .indexOf(':') +
                                                            1,
                                                        videoPlayerValue.duration
                                                            .toString()
                                                            .indexOf('.')),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 22),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                ))
                          ],
                        ),
                      ),
                    ])),
              ),
            ),
          );
        }
      },
    );
  }
}
