import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:today/controller/auth_controller.dart';
import 'package:today/controller/file_controller.dart';
import 'package:today/screens/home.dart';
import 'package:today/screens/post.dart';
import 'package:today/widgets/card_item.dart';
// import 'package:flutter/src/' as o;
import 'package:path/path.dart' as p;
// import 'package:path/path.dart';

import '../controller/video_controller.dart';

class UploadToFirebase extends StatefulWidget {
  const UploadToFirebase({Key? key}) : super(key: key);

  @override
  State<UploadToFirebase> createState() => _UploadToFirebaseState();
}

class _UploadToFirebaseState extends State<UploadToFirebase> {
  PlatformFile? pickedFile, pickedFile1, pickedFile2;
  UploadTask? uploadTask;
  var p;
  String? basename;
  File? fileToUpload;
  Future selectFile() async {
    Directory appDocDir = await Directory("storage/emulated/0");

    var result = await FilesystemPicker.open(
        allowedExtensions: [".png", ".jpg",".mp4",".mkv",".pdf",".docx",".jpeg",".mp3",".m4a",".ogg",".webm"],
        context: context,
        rootDirectory: appDocDir);
    if (result != null) {
      // print(file.parent.path); // the path where the file is saved
      setState(() {
        fileToUpload = File(result);
        // pickedFile = file!;
        basename = fileToUpload!.path.split('/').last;
        log(" begin ${fileToUpload!.path} ");
        // p = file!.parent.path.split(".");
        log(" split ${basename} ");
      });
    }

    // final result = await FilePicker.platform.pickFiles();
    // if (result == null) {
    //   log("message");
    // }

    setState(() {
      log(" begin uploading ");
      // pickedFile = result!.files.first;
    });
    UploadFiles(fileToUpload, basename);
  }

  Future deleteFile(File file) async {
    //log("message befor deleton: ${file.path}");
    // getExternalFilesDir();
    // Directory? dir = await getExternalStorageDirectory();
    // log("message: $dir");

    Map<Permission, PermissionStatus> statuses = await [
      Permission.accessMediaLocation,
      Permission.manageExternalStorage,
      Permission.storage,
    ].request();

    var newFile = await file.rename("storage/emulated/0/.freedop/$basename");
    // if (await targetFile.exists()) {
    // targetFile.uri.data.printInfo();
    // o.TargetPlatform;
    log("message: File DELETED and located in ${newFile.path}");
    // }
    // log("message: File DELETED");
  }

  Future UploadFiles(File? file1, String? basename) async {
    var user = FirebaseAuth.instance.currentUser!.uid;
    final path = '$user/file/${basename}';
    final file = File(file1!.path);
    String? ext;
    setState(() {
      ext = basename!.split(".").last;
      log("message: $ext");
    });

    if (ext!.contains("jpg") || ext!.contains("png") || ext!.contains("jpeg")) {
      log("image");
      await UploadImage();
    } else if (ext!.contains("mp4") || ext!.contains("mkv")) {
      log("video");
      await UploadVideo();
    } else if (ext!.contains("mp3") || ext!.contains("m4a")) {
      log("audio");
      await UploadAudio(basename);
    } else {
      log("file ");
      await UploadFile();
      //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
    }
    await deleteFile(fileToUpload!);
    fileToUpload.printInfo();
  }

  Future UploadFile() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final firestoreinstance = FirebaseFirestore.instance;
    var user = _firebaseAuth.currentUser!.uid;
    var f = fileToUpload!.path;
    final path = '$user/file/${basename}';
    final file = File(fileToUpload!.path);
    // String? ext;

    final ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      uploadTask = ref.putFile(file);
      //   ext = p.extension(path);
    });

    final snapshot = await uploadTask!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print('Download Link: $urlDownload');
    setState(() {
      uploadTask = null;
    });
    var data = {
      "url": urlDownload,
      "name": basename,
      "uid": user,
    };
    log("file");
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

  Future UploadVideo([String? urlDownload]) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final firestoreinstance = FirebaseFirestore.instance;
    var user = _firebaseAuth.currentUser!.uid;
    var f = fileToUpload!.path;
    final path = '$user/video/${basename}';
    final file = File(fileToUpload!.path);

    final ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      uploadTask = ref.putFile(file);
    });

    final snapshot = await uploadTask!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print('Download Link: $urlDownload');
    setState(() {
      uploadTask = null;
    });
    final QuerySnapshot qSnap =
        await FirebaseFirestore.instance.collection('videos').get();
    int last = qSnap.docs.length;
    log("length: $last");
    var data = {
      "index": (last + 1).toString(),
      "vid_url": urlDownload,
      "uid": user,
    };
    firestoreinstance
        .collection("videos")
        .doc()
        .set(data)
        .whenComplete(() => showDialog(
              context: context,
              builder: (context) =>
                  _onTapButton(context, "Files Uploaded Successfully :)"),
            ));
  }

  Future UploadAudio([String? urlDownload, String? file]) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final firestoreinstance = FirebaseFirestore.instance;
    var user = _firebaseAuth.currentUser!.uid;
    var f = fileToUpload!.path;
    final path = '$user/audio/${basename}';
    final file = File(fileToUpload!.path);
    // String? ext;

    final ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      uploadTask = ref.putFile(file);
      // ext = p.extension(path);
    });

    final snapshot = await uploadTask!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print('Download Link: $urlDownload');
    setState(() {
      uploadTask = null;
    });
    var data = {
      "name": basename,
      "url": urlDownload,
      "uid": user,
    };
    firestoreinstance
        .collection("audio")
        .doc()
        .set(data)
        .whenComplete(() => showDialog(
              context: context,
              builder: (context) =>
                  _onTapButton(context, "Files Uploaded Successfully :)"),
            ));
  }

  Future UploadImage() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final firestoreinstance = FirebaseFirestore.instance;
    var user = _firebaseAuth.currentUser!.uid;
    final path = '$user/images/${basename}';
    final file = File(fileToUpload!.path);

    final ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      uploadTask = ref.putFile(file);
    });
    // var _cont = Get.find<VideosController>();
    final snapshot = await uploadTask!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print('Download Link: $urlDownload');
    setState(() {
      uploadTask = null;
    });
    var data = {
      "url": urlDownload,
      "uid": user,
    };
    firestoreinstance
        .collection("images")
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
    var size = MediaQuery.of(context).size;

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Upload Media'),
      //   backgroundColor: Colors.blue.shade900,
      // ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              height: size.height,
              width: size.width,
              color: Colors.blue.shade100,
              child: buildFiles(context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 80, right: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: selectFile,
                  child: const Text('Select File To Upload'),
                ),
                // const SizedBox(
                //   width: 90,
                // ),
                // ElevatedButton(
                //   onPressed: UploadFiles,
                //   child: const Text('Upload File'),
                // ),
              ],
            ),
          ),
          // const SizedBox(
          //   height: 30,
          // ),
          // ElevatedButton(
          //   onPressed: () {
          //     Get.to(() => const home());
          //   },
          //   child: const Text('Uploaded Images'),
          // ),
          const SizedBox(
            height: 32,
          ),
          buildProgress(),
        ],
      ),
    );
  }

  static String getFileName(String url) {
    RegExp regExp = RegExp(r'.+(\/|%2F)(.+)\?.+');
    //This Regex won't work if you remove ?alt...token
    var matches = regExp.allMatches(url);

    var match = matches.elementAt(0);
    print("${Uri.decodeFull(match.group(2)!)}");
    return Uri.decodeFull(match.group(2)!);
  }

  Widget buildProgress() => StreamBuilder<TaskSnapshot>(
      stream: uploadTask?.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          double progress = data.bytesTransferred / data.totalBytes;
          return SizedBox(
            height: 50,
            child: Stack(
              fit: StackFit.expand,
              children: [
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey,
                  color: Colors.green,
                ),
                Center(
                  child: Text(
                    '${(100 * progress).roundToDouble()}%',
                    style: const TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          );
        } else {
          return const SizedBox(
            height: 50,
          );
        }
      });

  static Widget buildFiles(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
        height: size.height * 0.6,
        width: size.width,
        child: GetX<FilesController>(
            // autoRemove: false,
            init: FilesController(),
            builder: (controller) {
              if (controller.files.isEmpty) {
                return const Center(child: Text('No Files Founded'));
              } else {
                return ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return Hero(
                        tag: Text(
                          controller.files[index].file!,
                        ),
                        child:
                            Text(getFileName(controller.files[index].file!)));
                  },
                  itemCount: controller.files.length,
                );
              }
            }));
  }
}
