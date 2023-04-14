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
  // final FocusNode myFocusNodeEmailLogin = FocusNode();
  // final FocusNode myFocusNodePasswordLogin = FocusNode();
  // final FocusNode myFocusNodePassword = FocusNode();
  // final FocusNode myFocusNodeEmail = FocusNode();
  // final FocusNode myFocusNodeName = FocusNode();
  // final FocusNode myFocusNodeNumber = FocusNode();
  // PageController _pageController = PageController();

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
        // backgroundColor: ThemeColors.loginGradientStart,
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
                      // log("message");

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
                                // fit: BoxFit.cover,
                                scale: 1.0,
                              ),
                            ), // DecorationImage(image: FileImage(File(file.path)),),
                    ),
                  ),
                ),
                // ),

                Column(
                  children: [
                    TextField(
                        keyboardType: TextInputType.name,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          logic.name.text = value;
                          //Do something with the user input.
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
                          //Do something with the user input.
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
                          //Do something with the user input.
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
                              // try {
                              //   logic.register();
                              // } catch (e) {
                              //   print(e);
                              // }
                              //   final user = await _auth.signInWithEmailAndPassword(
                              //       email: email, password: password);
                              //   if (user != null) {
                              //     Navigator.push(context,
                              //         MaterialPageRoute(builder: (context) => home()));
                              //   }
                              // } catch (e) {
                              //   print(e);
                              // }
                              // setState(() {
                              //   showSpinner = false;
                              // });
                            })),
                  ],
                ),
                // TextButton(
                //     child: Text('Register'),
                //     onPressed: () {
                //       Get.to(()=>RegisterScreen());
                //     }),
              ],
            ),
          ),
        ),
      );
    });
  }
}

 /*  Widget _buildSignUp(BuildContext context) { */
  //   return Container(
  //     padding: const EdgeInsets.only(top: 15.0),
  //     child: Column(
  //       children: <Widget>[
  //         Stack(
  //           clipBehavior: Clip.none,
  //           alignment: Alignment.topCenter,
  //           children: <Widget>[
  //             Card(
  //               elevation: 2.0,
  //               color: Colors.white,
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(8.0),
  //               ),
  //               child: SizedBox(
  //                 width: 300.0,
  //                 height: 460.0,
  //                 child: Column(
  //                   children: <Widget>[
  //                     Padding(
  //                       padding: const EdgeInsets.only(
  //                           top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
  //                       child: GetBuilder<AuthController>(
  //                         builder: (logic) {
  //                           return TextField(
  //                             focusNode: myFocusNodeName,
  //                             controller: logic.name,
  //                             keyboardType: TextInputType.text,
  //                             textCapitalization: TextCapitalization.words,
  //                             style: const TextStyle(
  //                                 fontFamily: "WorkSansSemiBold",
  //                                 fontSize: 16.0,
  //                                 color: Colors.black),
  //                             decoration: const InputDecoration(
  //                               border: InputBorder.none,
  //                               icon: Icon(
  //                                 Icons.person,
  //                                 color: Colors.black,
  //                               ),
  //                               hintText: "الاسم",
  //                               hintStyle: TextStyle(
  //                                   fontFamily: "WorkSansSemiBold",
  //                                   fontSize: 16.0),
  //                             ),
  //                           );
  //                         },
  //                       ),
  //                     ),
  //                     Container(
  //                       width: 250.0,
  //                       height: 1.0,
  //                       color: Colors.grey[400],
  //                     ),
  //                     Padding(
  //                       padding: const EdgeInsets.only(
  //                           top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
  //                       child: GetBuilder<AuthController>(
  //                         builder: (logic) {
  //                           return TextField(
  //                             focusNode: myFocusNodeEmail,
  //                             controller: logic.email,
  //                             keyboardType: TextInputType.emailAddress,
  //                             style: const TextStyle(
  //                                 fontFamily: "WorkSansSemiBold",
  //                                 fontSize: 16.0,
  //                                 color: Colors.black),
  //                             decoration: const InputDecoration(
  //                               border: InputBorder.none,
  //                               icon: Icon(
  //                                 Icons.email,
  //                                 color: Colors.black,
  //                               ),
  //                               hintText: "البريد الالكتروني",
  //                               hintStyle: TextStyle(
  //                                   fontFamily: "WorkSansSemiBold",
  //                                   fontSize: 16.0),
  //                             ),
  //                           );
  //                         },
  //                       ),
  //                     ),
  //                     Container(
  //                       width: 250.0,
  //                       height: 1.0,
  //                       color: Colors.grey[400],
  //                     ),
  //                     Padding(
  //                       padding: const EdgeInsets.only(
  //                           top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
  //                       child: GetBuilder<AuthController>(
  //                         id: 'reOb',
  //                         builder: (logic) {
  //                           return TextField(
  //                             focusNode: myFocusNodePassword,
  //                             controller: logic.password,
  //                             obscureText: logic.obscureTextSignup,
  //                             style: const TextStyle(
  //                                 fontFamily: "WorkSansSemiBold",
  //                                 fontSize: 16.0,
  //                                 color: Colors.black),
  //                             decoration: InputDecoration(
  //                                 border: InputBorder.none,
  //                                 icon: const Icon(
  //                                   Icons.lock,
  //                                   color: Colors.black,
  //                                 ),
  //                                 hintText: "كلمة السر",
  //                                 hintStyle: const TextStyle(
  //                                     fontFamily: "WorkSansSemiBold",
  //                                     fontSize: 16.0),
  //                                 suffixIcon: GestureDetector(
  //                                   onTap: () {
  //                                     logic.toggleSignup();
  //                                   },
  //                                   child: Icon(
  //                                     logic.obscureTextSignup
  //                                         ? Icons.visibility
  //                                         : Icons.visibility_off,
  //                                     size: 15.0,
  //                                     color: Colors.black,
  //                                   ),
  //                                 )),
  //                           );
  //                         },
  //                       ),
  //                     ),
  //                     Container(
  //                       width: 250.0,
  //                       height: 1.0,
  //                       color: Colors.grey[400],
  //                     ),
  //                     Padding(
  //                       padding: const EdgeInsets.only(
  //                           top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
  //                       child: GetBuilder<AuthController>(
  //                         id: 'RreOb',
  //                         builder: (logic) {
  //                           return TextField(
  //                             controller: logic.repassword,
  //                             obscureText: logic.obscureTextSignupConfirm,
  //                             style: const TextStyle(
  //                                 fontFamily: "WorkSansSemiBold",
  //                                 fontSize: 16.0,
  //                                 color: Colors.black),
  //                             decoration: InputDecoration(
  //                                 border: InputBorder.none,
  //                                 icon: const Icon(
  //                                   Icons.lock,
  //                                   color: Colors.black,
  //                                 ),
  //                                 hintText: "تأكيد كلمة السر",
  //                                 hintStyle: const TextStyle(
  //                                     fontFamily: "WorkSansSemiBold",
  //                                     fontSize: 16.0),
  //                                 suffixIcon: GestureDetector(
  //                                   onTap: () {
  //                                     logic.toggleSignupConfirm();
  //                                   },
  //                                   child: Icon(
  //                                     logic.obscureTextSignupConfirm
  //                                         ? Icons.visibility
  //                                         : Icons.visibility_off,
  //                                     size: 15.0,
  //                                     color: Colors.black,
  //                                   ),
  //                                 )),
  //                           );
  //                         },
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             Container(
  //               margin: EdgeInsets.only(top: 450.0),
  //               decoration: const BoxDecoration(
  //                 borderRadius: BorderRadius.all(Radius.circular(5.0)),
  //                 boxShadow: <BoxShadow>[
  //                   BoxShadow(
  //                     color: theme.Colors.loginGradientStart,
  //                     offset: Offset(1.0, 6.0),
  //                     blurRadius: 20.0,
  //                   ),
  //                   BoxShadow(
  //                     color: theme.Colors.loginGradientEnd,
  //                     offset: Offset(1.0, 6.0),
  //                     blurRadius: 20.0,
  //                   ),
  //                 ],
  //                 gradient: LinearGradient(
  //                     colors: [
  //                       theme.Colors.loginGradientEnd,
  //                       theme.Colors.loginGradientStart
  //                     ],
  //                     begin: FractionalOffset(0.2, 0.2),
  //                     end: FractionalOffset(1.0, 1.0),
  //                     stops: [0.0, 1.0],
  //                     tileMode: TileMode.clamp),
  //               ),
  //               child: GetBuilder<AuthController>(
  //                 builder: (logic) {
  //                   return MaterialButton(
  //                     highlightColor: Colors.transparent,
  //                     splashColor: theme.Colors.loginGradientEnd,
  //                     //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
  //                     child: const Padding(
  //                       padding: EdgeInsets.symmetric(
  //                           vertical: 10.0, horizontal: 42.0),
  //                       child: Text(
  //                         "تسجيل",
  //                         style: TextStyle(
  //                             color: Colors.white,
  //                             fontSize: 25.0,
  //                             fontFamily: "WorkSansBold"),
  //                       ),
  //                     ),
  //                     onPressed: () async {
  //                       logic.register();
  //                     },
  //                   );
  //                 },
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

