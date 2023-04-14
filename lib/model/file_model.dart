import 'package:cloud_firestore/cloud_firestore.dart';

class Files {
  String? id;
  String? name;
  String? file;

  Files({
    this.id,
    required this.name,
    required this.file,
  });

  Files.fromMap(DocumentSnapshot data) {
    id = data.id;
    name = data["name"];
    file = data["url"];
  }
}
