import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:today/model/photo_model.dart';
import 'package:today/model/video_model.dart';

class HomeController extends GetxController {
  RxList<Photos> photos = RxList<Photos>([]);
  List<Photos> list = [];

  RxList<Videos> videos = RxList<Videos>([]);
  List<Videos> vid_list = [];
  // RxList<Resrvation> reservaiton = RxList<Resrvation>([]);
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  late CollectionReference collectionReference, vid_ref;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  auth.User? user;
  @override
  void onInit() {
    user = FirebaseAuth.instance.currentUser;
    collectionReference = firebaseFirestore.collection("images");
    vid_ref = firebaseFirestore.collection("videos");
    photos.bindStream(getAllPhotos());
    // videos.bindStream(getAllVideos());
    super.onInit();
  }

  Stream<List<Photos>> getAllPhotos() => collectionReference
      .where('uid', isEqualTo: user!.uid)
      .snapshots()
      .map((query) => query.docs.map((item) => Photos.fromMap(item)).toList());

  String? validate(String value) {
    if (value.isEmpty) {
      return "please enter this filed";
    }

    return null;
  }


}
