import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:today/controller/auth_controller.dart';
import 'package:today/screens/home.dart';
import 'package:today/widgets/loading.dart';
import 'package:today/widgets/snackbar.dart';
import 'package:today/widgets/theme.dart' as theme;
import 'package:today/widgets/theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  AuthController controller = Get.find();
  late String email;
  late String name;
  late String password;
  bool showSpinner = false;

  static const kTextFieldDecoration = InputDecoration(
      icon: Icon(
        Icons.email,
        color: Colors.white,
      ),
      hintText: 'Enter a value',
      hintStyle: TextStyle(color: Colors.grey),
      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
      ));
  static const passDecoration = InputDecoration(
      icon: Icon(
        Icons.security,
        color: Colors.white,
      ),
      hintText: 'Enter a value',
      hintStyle: TextStyle(color: Colors.grey),
      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
      ));
  static const nameDecoration = InputDecoration(
      icon: Icon(
        Icons.person,
        color: Colors.white,
      ),
      hintText: 'Enter a value',
      hintStyle: TextStyle(color: Colors.grey),
      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
      ));

  final _auth = FirebaseAuth.instance;
  PlatformFile? pickedFile;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (logic) {
      return Scaffold(
        body: Container(
          decoration:
              const BoxDecoration(gradient: ThemeColors.primaryGradient),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "Welcome to Your Free Domain OF Privacy",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.4,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(
                  height: 50.0,
                ),
                Container(
                  height: 90,
                  width: 90,
                  child: GestureDetector(
                    onTap: () async {
                      final result = await FilePicker.platform.pickFiles();
                      if (result == null) {
                        log("message");
                      }

                      setState(() {
                        log(" begin uploading ");
                        pickedFile = result!.files.first;
                      });
                    },
                    child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: pickedFile == null
                            ? const Icon(
                                Icons.add_photo_alternate_outlined,
                                size: 40,
                              )
                            : CircleAvatar(
                                radius: 50.0,
                                backgroundColor: Colors.transparent,
                                backgroundImage: FileImage(
                                  File(pickedFile!.path!),
                                  scale: 1.0,
                                ),
                              )),
                  ),
                ),
                Column(
                  children: [
                    TextField(
                        keyboardType: TextInputType.name,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          logic.name.text = value;
                        },
                        decoration: nameDecoration.copyWith(
                          hintText: 'Enter your name',
                        )),
                    const SizedBox(
                      height: 8.0,
                    ),
                    TextField(
                        keyboardType: TextInputType.emailAddress,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          logic.email.text = value;
                        },
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter your email',
                        )),
                    const SizedBox(
                      height: 8.0,
                    ),
                    TextField(
                        obscureText: true,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          logic.password.text = value;
                        },
                        decoration: passDecoration.copyWith(
                            hintText: 'Enter your password.')),
                    const SizedBox(
                      height: 24.0,
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            gradient: ThemeColors.loginbtn,
                            borderRadius: BorderRadius.circular(20)),
                        child: TextButton(
                            child: const Text(
                              'Register',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              logic.register(pickedFile);
                            })),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}