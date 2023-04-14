import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  String? id;
  String? name;
  String? profile;
  String? email;


  Users({
    this.id,
    required this.name,
    required this.profile,
    required this.email
  });

  Users.fromMap(DocumentSnapshot data) {
    id = data.id;
    name = data["name"];
    profile = data["profile"];
    email = data["email"];
  }
}
