import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:today/controller/home_controller.dart';
import 'package:today/screens/video.dart';
// import 'package:today/widgets/property.dart';

class post extends StatelessWidget {


  final FirebaseAuth? auth = FirebaseAuth.instance;
  Stream<QuerySnapshot<Object?>> getUserRd(BuildContext context) async* {
    final rd = await auth!.currentUser;
    yield* FirebaseFirestore.instance
        .collection("images")
        .where('uid', isEqualTo: rd!.uid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return buildPhoto(context);
  }

  static Widget buildPhoto(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
        height: size.height * 0.6,
        width: size.width,
        child: GetX<HomeController>(
            // autoRemove: false,
            init: HomeController(),
            builder: (controller) {
              if (controller.photos.isEmpty) {
                return const Center(child: Text('No photos Founded'));
              } else {
                return ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return Hero(
                        tag: Image.network(
                          controller.photos[index].image!,
                          fit: BoxFit.contain,
                          height: size.height / 2,
                        ),
                        child: Image.network(
                          controller.photos[index].image!,
                          fit: BoxFit.contain,
                          height: size.height / 2,
                        ));
                  },
                  itemCount: controller.photos.length,
                );
              }
            }));
  }

  // static Widget buildVideo(BuildContext context) {
  //   var size = MediaQuery.of(context).size;
  //   return Container(
  //       height: size.height * 0.6,
  //       width: size.width,
  //       child: GetX<HomeController>(
  //           // autoRemove: false,
  //           init: HomeController(),
  //           builder: (controller) {
  //             if (controller.videos.isEmpty) {
  //               return const Center(child: Text('No Video Founded'));
  //             } else {
  //               return ListView.builder(
  //                 itemBuilder: (BuildContext context, int index) {
  //                   return Hero(
  //                       tag: Image.network(
  //                         controller.videos[index].vid!,
  //                         fit: BoxFit.contain,
  //                         height: size.height / 2,
  //                       ),
  //                       child: VideoScreen(),
  //                 },
  //                 itemCount: controller.videos.length,
  //               );
  //             }
  //           }));
  // }
}
