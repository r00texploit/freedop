import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:get/get.dart';
import 'package:today/model/video_model.dart';

class VideosController extends GetxController {
  RxList<Videos> videos = RxList<Videos>([]);
  List<Videos> vid_list = [];
  late CollectionReference vid_ref;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  List<String>? paths;

  auth.User? user;

  @override
  void onInit() {
    user = FirebaseAuth.instance.currentUser;
    vid_ref = firebaseFirestore.collection("videos");

    videos.bindStream(getAllVideos());
    videoPath();
    super.onInit();
  }

  Stream<List<Videos>> getAllVideos() => vid_ref
      .where('uid', isEqualTo: user!.uid)
      .snapshots()
      .map((query) => query.docs.map((item) => Videos.fromMap(item)).toList());

  videoPath() {
    for (var element in videos) {
      paths!.add(element.vid!);
      update();
    }
  }

  int counter() {
    int count = 0;
    for (var i = 0; i < videos.length; i++) {
      count += 1;
    }
    return count;
  }

  int get lastIndex => videos.indexOf(counter());
}
