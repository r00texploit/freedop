import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../model/firebase_file.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

class FirebaseApi extends GetxController {
  static Future<List<String>> _getDownloadLinks(List<Reference> refs) =>
      Future.wait(refs.map((ref) => ref.getDownloadURL()).toList());

  static Future<List<FirebaseFile>> listAll(String path) async {
    final ref = FirebaseStorage.instance.ref(path);
    final result = await ref.listAll();

    final urls = await _getDownloadLinks(result.items);

    return urls
        .asMap()
        .map((index, url) {
          final ref = result.items[index];
          final name = ref.name;
          final file = FirebaseFile(ref: ref, name: name, url: url);

          return MapEntry(index, file);
        })
        .values
        .toList();
  }

  static Future deleteFile(File file) async {
    final dir = Directory('/storage/emulated/0/Download');
    var f = File("${dir.path}/${file.path}");
    if (!await f.exists()) {
      log("message: not found");

      return null;
    }
    f.delete();
    log("message file1:${f.path} ");
    log("message file2:${file.path} ");
  }

  deleteFirebase(Reference ref) async {
    var url = await FirebaseFirestore.instance
        .collection("images")
        // .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("url", isEqualTo: ref.getDownloadURL().toString())
        .snapshots();
    var str;
    url.map(
      (event) => event.docs.map((e) { 
        str = e.data();
        update();
      })//.toList(),
    ).toList();
    log("url:${str.toString()}");
    str.delete();
    update();
    ref.delete();
    
    Get.back();
  }

  static Future downloadFile(Reference ref) async {
    final dir = Directory('/storage/emulated/0/Download');
    final file = File('${dir.path}/${ref.name}');
    log("message file:${file.path} ");
    await ref.writeToFile(file);
  }
}
