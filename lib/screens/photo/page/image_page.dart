import 'dart:developer';
import 'dart:io';

import '../api/firebase_api.dart';
import '../model/firebase_file.dart';
import 'package:flutter/material.dart';

class ImagePage extends StatelessWidget {
  final FirebaseFile file;

  const ImagePage({
    Key? key,
    required this.file,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isImage = ['.jpeg', '.jpg', '.png'].any(file.name.contains);

    return Scaffold(
        appBar: AppBar(
          title: Text(file.name),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.file_download),
              onPressed: () async {
                await FirebaseApi.downloadFile(file.ref);
                log("message: ${file.url}");
                final snackBar = SnackBar(
                  content: Text('Downloaded ${file.name}'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),

            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                var f = File(file.name);
                var d = await FirebaseApi.deleteFile(f);
                log("message: ${file.url}");
                if (d == null) {
                  final delete = SnackBar(
                    content: Text('not downloaded ${file.name}'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(delete);
                }
                final snackBar = SnackBar(
                  content: Text('deleted ${file.name}'),
                );
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
              IconButton(
              icon: Icon(Icons.remove_circle),
              onPressed: () async {
                await FirebaseApi().deleteFirebase(file.ref);
                log("message: ${file.url}");
                final snackBar = SnackBar(
                  content: Text('Deleted ${file.name}'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
            const SizedBox(width: 12),
          ],
        ),
        body: //isImage
            Container(
          width: MediaQuery.of(context).size.width,
          child: Image.network(
            file.url,
            height: double.infinity,
            fit: BoxFit.contain,
          ),
        ));
  }
}
