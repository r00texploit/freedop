import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:today/controller/video_controller.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatelessWidget {
  // Create the initialization Future outside of build
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          // Check for error
          if (snapshot.hasError) {
            print(snapshot.error);
            return Center(
              child: Container(
                child: Text(
                  "Something went wrong",
                  textDirection: TextDirection.ltr,
                ),
              ),
            );
          }

          //Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              title: 'Flutter Demo',
              debugShowCheckedModeBanner: false,
              home: VideoPlayerScreen(),
            );
          }

          return CircularProgressIndicator();
        });
  }
}

class VideoPlayerScreen extends StatefulWidget {
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? videoUrl;
  // 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4';

  @override
  void initState() {
    super.initState();
    firestore.collection("videos").get().then((QuerySnapshot querySnapshot) => {
          querySnapshot.docs.forEach((doc) {
            videoUrl = doc["vid_url"];
            _controller = VideoPlayerController.network(videoUrl!);
            _initializeVideoPlayerFuture = _controller.initialize().then((_) {
              // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
              setState(() {});
            });
            _controller.setLooping(true);
            _controller.setVolume(1.0);
            super.initState();
          })
        });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    VideosController controller = Get.put(VideosController());
    return Scaffold(
      body: GetX<VideosController>(
        // init: HomeController(),
        builder: ((controller) {
          if (controller.videos.isEmpty) {
            return const Center(child: Text('No Videos Founded'));
          } else {
            // return ListView.builder(
            //     itemBuilder: (BuildContext context, int index) {
            return FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return GridView.builder(  
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    // mainAxisSize: MainAxisSize.min,
                    // children: [
                      itemCount: controller.videos.length ,
                      itemBuilder: (BuildContext context, int index) {  
                      return Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          // AspectRatio(
                          //   aspectRatio: _controller.value.aspectRatio,
                          //   child: VideoPlayer(_controller),
                          // ),
                          FloatingActionButton(
                            onPressed: () {
                              // Wrap the play or pause in a call to `setState`. This ensures the
                              // correct icon is shown.
                              setState(() {
                                // If the video is playing, pause it.
                                if (_controller.value.isPlaying) {
                                  _controller.pause();
                                } else {
                                  // If the video is paused, play it.
                                  _controller.play();
                                }
                              });
                            },
                            // Display the correct icon depending on the state of the player.
                            child: Icon(
                              _controller.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                            ),
                          ),
                        ],
                      );
                      }, gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                    // , ],
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            );
            // });
          }
        }),
      ),
    );
  }
}
