import 'package:cloud_firestore/cloud_firestore.dart';

class Videos {
  String? id;
  String? vid;
  String? index;

  Videos({
    this.id,
    required this.vid,
    this.index,
  });

  Videos.fromMap(DocumentSnapshot data) {
    id = data.id;
    vid = data["vid_url"];
    index = data["index"];
  }
}
