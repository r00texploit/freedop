import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:get/get.dart';
import 'package:today/model/audio_model.dart';
import 'package:today/model/video_model.dart';

class AudiosController extends GetxController {
  RxList<Audio> audios = RxList<Audio>([]);
  List<Videos> vid_list = [];
  late CollectionReference aud_ref;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  auth.User? user;

  @override
  void onInit() {
    user = FirebaseAuth.instance.currentUser;
    aud_ref = firebaseFirestore.collection("audio");

    audios.bindStream(getAllAudios());
    super.onInit();
  }

  

  Stream<List<Audio>> getAllAudios() => aud_ref
      .where('uid', isEqualTo: user!.uid)
      .snapshots()
      .map((query) => query.docs.map((item) => Audio.fromMap(item)).toList());
}
