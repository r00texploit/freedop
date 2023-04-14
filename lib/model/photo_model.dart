import 'package:cloud_firestore/cloud_firestore.dart';

class Photos {
  String? id;
  String? image;

  Photos({
    this.id,
    required this.image,
  });

  Photos.fromMap(DocumentSnapshot data) {
    id = data.id;
    image = data["url"];
  }
}
