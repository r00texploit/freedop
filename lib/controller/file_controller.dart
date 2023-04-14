import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:today/model/file_model.dart';

class FilesController extends GetxController {
  RxList<Files> files = RxList<Files>([]);
  List<Files> file_list = [];
  late CollectionReference file_ref;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  late FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  auth.User? user;

  @override
  void onInit() {
    user = FirebaseAuth.instance.currentUser;
    file_ref = firebaseFirestore.collection("files");

    files.bindStream(getAllFiles());
    super.onInit();
  }

  Stream<List<Files>> getAllFiles() => file_ref
      .where('uid', isEqualTo: user!.uid)
      .snapshots()
      .map((query) => query.docs.map((item) => Files.fromMap(item)).toList());

  Future<void> downloadFileExample() async {
    //First you get the documents folder location on the device...
    Directory appDocDir = await getApplicationDocumentsDirectory();
    //Here you'll specify the file it should be saved as
    File downloadToFile = File('${appDocDir.path}/');
    //Here you'll specify the file it should download from Cloud Storage
    String fileToDownload = 'uploads/uploaded-pdf.pdf';

    //Now you can try to download the specified file, and write it to the downloadToFile.
    try {
      await firebaseStorage.ref(fileToDownload).writeToFile(downloadToFile);
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print('Download error: $e');
    }
  }
}
