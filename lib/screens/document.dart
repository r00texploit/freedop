import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:today/controller/file_controller.dart';
import 'package:today/controller/home_controller.dart';

class Document extends StatelessWidget {
  final FirebaseAuth? auth = FirebaseAuth.instance;
  Stream<QuerySnapshot<Object?>> getUserRd(BuildContext context) async* {
    final rd = await auth!.currentUser;
    yield* FirebaseFirestore.instance
        .collection("files")
        .where('uid', isEqualTo: rd!.uid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return buildDoc(context);
  }

  static Widget buildDoc(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
        height: size.height * 0.6,
        width: size.width,
        color: Theme.of(context).backgroundColor,
        child: GetX<FilesController>(
            init: FilesController(),
            builder: (controller) {
              if (controller.files.isEmpty) {
                return const Center(child: Text('No Files Founded'));
              } else {
                return ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        margin: EdgeInsets.only(top: 10),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        height: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: LinearGradient(colors: [
                              Color(0xFF42A5F5),
                              Color.fromARGB(15, 42, 197, 244),
                            ])),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 15,
                            top: 20,
                            bottom: 5,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                controller.files[index].name!,
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                              IconButton(
                                onPressed: () async {
                                  final dir =
                                      Directory('/storage/emulated/0/Download');
                                  final file = File(
                                      '${dir.path}/${controller.files[index].name!}');
                                  log("message file:${file.path}");
                                  log("message:${controller.files[index].file!}");
                                  var ref = FirebaseStorage.instance.refFromURL(
                                      controller.files[index].file!);
                                  await ref.writeToFile(file);
                                  final snackBar = SnackBar(
                                    content: Text(
                                        'Downloaded ${controller.files[index].name!}'),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                },
                                icon: Icon(Icons.download),
                                color: Colors.blue[900],
                              )
                            ],
                          ),
                        ));
                  },
                  itemCount: controller.files.length,
                );
              }
            }));
  }
}
