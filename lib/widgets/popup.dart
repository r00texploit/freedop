import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class PopUP extends StatefulWidget {
  const PopUP({super.key});

  @override
  State<PopUP> createState() => _PopUPState();
}

class _PopUPState extends State<PopUP> {
  static PlatformFile? pickedFile;
  static UploadTask? uploadTask;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future UploadFile() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final firestoreinstance = FirebaseFirestore.instance;
    var user = _firebaseAuth.currentUser!.uid;
    final path = '$user/${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      uploadTask = ref.putFile(file);
    });

    final snapshot = await uploadTask!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    log('Download Link: $urlDownload');
    setState(() {
      uploadTask = null;
    });
    var data = {
      "url": urlDownload,
      "uid": user,
    };
    firestoreinstance
        .collection("files")
        .doc()
        .set(data)
        .whenComplete(() => showDialog(
              context: context,
              builder: (context) =>
                  _onTapButton(context, "Files Uploaded Successfully :)"),
            ));
  }

  _onTapButton(BuildContext context, data) {
    return AlertDialog(title: Text(data));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20, top: 80, right: 20),
        child: Row(
          children: [
            ElevatedButton(
              onPressed: selectFile,
              child: const Text('Select File'),
            ),
            const SizedBox(
              width: 90,
            ),
            ElevatedButton(
              onPressed: UploadFile,
              child: const Text('Upload File'),
            ),
          ],
        ),
      ),
    );
  }
}
