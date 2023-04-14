import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_picker/src/platform_file.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:today/model/user_model.dart';
import 'package:today/screens/home.dart';
import 'package:today/screens/login.dart';
import 'package:today/widgets/loading.dart';
import 'package:today/widgets/snackbar.dart';

class AuthController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late TextEditingController email, password, Rpassword, repassword, name;
  String? profileurl;
  bool ob = false;
  bool obscureTextLogin = true;
  bool obscureTextSignup = true;
  bool obscureTextSignupConfirm = true;
  static AuthController instance = Get.find();
  late Rx<User?> _user;
  RxList<Users> user_profile = RxList<Users>([]);
  static FirebaseAuth auth = FirebaseAuth.instance;
  bool showSpinner = false;

  late Widget route;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<User?> get onAuthStateChanged => _firebaseAuth.authStateChanges();

  @override
  void onReady() {
    _user.bindStream(onAuthStateChanged);
    ever(_user, _initialScreen);
    super.onReady();
  }

  @override
  void onInit() {
    email = TextEditingController();
    password = TextEditingController();
    name = TextEditingController();
    // profileurl = "";
    _user = Rx<User?>(auth.currentUser);
    _user.bindStream(onAuthStateChanged);
    ever(_user, _initialScreen);
    super.onInit();
  }

  RxList<Users> photos = RxList<Users>([]);
  String? get user_ch => _user.value!.email;
  _initialScreen(User? user) {
    if (user == null) {
      route = LoginScreen();
    } else {
      route = const home();
    }
  }

  toggleLogin() {
    obscureTextLogin = !obscureTextLogin;

    update(['loginOb']);
  }

  toggleSignup() {
    obscureTextSignup = !obscureTextSignup;
    update(['reOb']);
  }

  toggleSignupConfirm() {
    obscureTextSignupConfirm = !obscureTextSignupConfirm;
    update(['RreOb']);
  }

  String? validate(String value) {
    if (value.isEmpty) {
      return "please enter this filed";
    }

    return null;
  }

  String? validateNumber(String value) {
    if (value.isEmpty) {
      return "please enter your Phone";
    }
    if (value.length < 10) {
      return "Phone length must be more than 10";
    }

    return null;
  }

  String? validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    if (value.isEmpty) {
      return "please enter your email";
    }

    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return "please enter your password";
    }
    if (value.length < 6) {
      return "password length must be more than 6 ";
    }
    return null;
  }

  String? validateRePassword(String value) {
    if (value.isEmpty) {
      return "please enter your password";
    }
    if (value.length < 6) {
      return "password length must be more than 6 ";
    }
    return null;
  }

  changeOb() {
    ob = !ob;
    update(['password']);
  }

  void signOut() async {
    Get.dialog(AlertDialog(
      content: const Text('هل تريد تسجيل الخروج من التطبيق'),
      actions: [
        TextButton(
            onPressed: () async {
              await auth
                  .signOut()
                  .then((value) => Get.offAll(() => LoginScreen()));
            },
            child: const Text('تاكيد')),
        TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('رجوع'))
      ],
    ));
  }

  void register(PlatformFile? pickedFile) async {
    if (name.text.isNotEmpty &&
        email.text.isNotEmpty &&
        password.text.isNotEmpty) {
      try {
        // SmartDialog.showLoading();
        // var con = AuthController();
        showdilog();
        final credential = await _firebaseAuth.createUserWithEmailAndPassword(
            email: email.text, password: password.text);
        credential.user!.updateDisplayName(name.text);
        var ref = FirebaseStorage.instance
            .ref()
            .child("${credential.user!.uid}/profile/${credential.user!.uid}");
        var up = ref.putFile(File(pickedFile!.path!));
        var profiletask = await up.whenComplete(() {});
        var prourl = await profiletask.ref.getDownloadURL();
        profileurl = prourl;
        credential.user!.updatePhotoURL(prourl);
        update();
        await credential.user!.reload();
        await FirebaseFirestore.instance
            .collection('user')
            .doc(credential.user!.uid)
            .set({
          'name': name.text,
          'profile': prourl,
          'email': email.text,
          'uid': credential.user!.uid,
        });

        showbar("About User", "User message", "تم التسجيل بنجاح!!", true);
        Get.to(() => const home());
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          Get.back();
          showbar("About Login", "Login message", 'الايميل محجوز مسبقا', false);
        }
        if (e.code == 'weak-password') {
          Get.back();
          showbar("About Login", "Login message", 'كلمة المرور ضعيفة', false);
        } else {
          Get.back();
          showbar("About User", "User message", e.toString(), false);
        }
      }
    } else {
      showbar(
          "About User", "User message", 'الرجاء ادخال جميع البيانات', false);
    }

    // setState(() {
    showSpinner = true;
    update();
    // });
  }

  // var uid = auth.currentUser!.uid;
  // var collectionReference = FirebaseFirestore.instance.collection("user");

  // Stream<List<Users>> getProfilePhoto() => collectionReference
  //     .where('uid', isEqualTo: uid)
  //     .snapshots()
  //     .map((query) => query.docs.map((item) => Users.fromMap(item)).toList());

  void login() async {
    // user_profile.bindStream(getProfilePhoto());
    if (email.text.isNotEmpty && password.text.isNotEmpty) {
      try {
        showdilog();
        await auth.signInWithEmailAndPassword(
            email: email.text, password: password.text);
        var profile = await FirebaseStorage.instance
            .ref()
            .child("${auth.currentUser!.uid}/profile/${auth.currentUser!.uid}")
            .getDownloadURL();
        Get.back();
        email.clear();
        password.clear();
        profileurl = profile;
        // var pu = await FirebaseFirestore.instance.collection("user").where("uid",isEqualTo: auth.currentUser!.uid).get();
        update();
        log("message:${profile}");
        Get.offAll(() => const home());
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Get.back();
          showbar("About Login", "Login message", 'كلمة السر ضعيفة', false);
        }
        if (e.code == 'email-already-in-use') {
          Get.back();
          showbar("About Login", "Login message", 'الايميل محجوز مسبقا', false);
        }
        if (e.code == 'user-not-found') {
          Get.back();
          showbar("About Login", "Login message", ' اليوزر غير موجود', false);
        } else {
          Get.back();
          showbar("About Login", "Login message", e.toString(), false);
        }
      }
    } else {
      showbar(
          "About Login", "Login message", 'الرجاء ادخال جميع البيانات', false);
    }
  }

  updateName() async {
    log("name: ${name.text}");
    await FirebaseAuth.instance.currentUser!.updateDisplayName(name.text);
    log("username: ${FirebaseAuth.instance.currentUser!.displayName}");
    name.clear();
    update();
  }
  passwordReset() async {
    try {
      // var cont = Get.put(AuthController());
      formKey.currentState!.save();
      final user = await auth.sendPasswordResetEmail(email: email.text);

      // ignore: use_build_context_synchronously
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) {
      //     return ConfirmEmail(message: widget.message,);
      //   }),
      // );
      Get.back();
      showbar("Reset","Password","An email has just been sent to you, Click the link provided to complete password reset",true);
    } catch (e) {
      print(e);
    }
  }


  updatePassword() async {
    await FirebaseAuth.instance.currentUser!.updatePassword(password.text);
    log("username: ${FirebaseAuth.instance.currentUser!.displayName}");
    log("password: ${password.text}");
    password.clear();
    update();
    Get.back();
    showbar("About User", "message", 'Password Updated Successful', true);
  }

  updateProfile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) {
      log("message");
    }

    // setState(() {
    log(" begin uploading ");
    var pickedFile = result!.files.first;
    var ref = FirebaseStorage.instance.ref().child(
        "${FirebaseAuth.instance.currentUser!.uid}/profile/${pickedFile.name}");
    var up = ref.putFile(File(pickedFile.path!));
    var profiletask = await up.whenComplete(() {});
    var prourl = await profiletask.ref.getDownloadURL();
    await FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"profile": prourl});
    log("message: Done");

    // });
  }
}
