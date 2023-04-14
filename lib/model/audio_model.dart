import 'package:cloud_firestore/cloud_firestore.dart';

class Audio {
  String? id;
  String? name;
  String? url;

  Audio({this.id, required this.url, required this.name});

  Audio.fromMap(DocumentSnapshot data) {
    id = data.id;
    name = data["name"];
    url = data["url"];
  }
}
