import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:today/controller/auth_controller.dart';
import 'package:today/widgets/file_upload.dart';
import 'package:today/widgets/theme.dart';
import 'package:today/widgets/theme/theme_model.dart';

class App_bar extends StatefulWidget {
  const App_bar({super.key});

  @override
  State<App_bar> createState() => _App_barState();
}

class _App_barState extends State<App_bar> {
  var user = FirebaseFirestore.instance;
  var theme = Get.find<ThemeModel>();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
        init: AuthController(),
        builder: ((logic) {
          // log("${logic.profileurl!}");
          // var con = Get.find<>
          // var profile = FirebaseFirestore.instance.collection("user").doc(FirebaseAuth.instance.currentUser!.uid).get();
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 30.0,
                  backgroundImage: logic.profileurl == null ? NetworkImage("https://www.pngfind.com/pngs/m/610-6104451_image-placeholder-png-user-profile-placeholder-image-png.png") : NetworkImage(logic.profileurl!),
                  backgroundColor: Colors.transparent,
                ),
                Row(
                  children: [
                    // CircleAvatar(
                    //   radius: 21,
                    //   backgroundColor: Colors.grey.shade300,
                    //   child: Icon(
                    //     Icons.search,
                    //     size: 26,
                    //     color: Colors.grey.shade600,
                    //   ),
                    // ),
                    const SizedBox(width: 13),
                    CircleAvatar(
                      radius: 21,
                      backgroundColor: Colors.grey.shade300,
                      child: IconButton(
                          onPressed: () {
                            // AuthController authController = AuthController();
                            logic.signOut();
                          },
                          icon: const Icon(Icons.logout)),
                    ),
                    const SizedBox(width: 13),
                    CircleAvatar(
                      radius: 21,
                      backgroundColor: Colors.grey.shade300,
                      child: IconButton(
                          onPressed: () {
                              theme.setisDark(!theme.isDark);
                            // log(themeNotifier.isDark.toString());
                          },
                          icon: const Icon(
                            Icons.sunny,
                            color: Colors.white,
                          )),
                    ),
                    //   InkWell(
                    //   onTap: () {
                    //     var themeNotifier = ThemeModel();
                    //     themeNotifier.isDark
                    //         ? themeNotifier.isDark = false
                    //         : themeNotifier.isDark = true;
                    //   },
                    //   child: const ListTile(
                    //     leading: Icon(
                    //       Icons.dark_mode,
                    //     ),
                    //     title: Text(
                    //       "المظهر الليلي",
                    //       style: TextStyle(
                    //         fontSize: 15,
                    //       ),
                    //     ),
                    //   ),
                    // )
                  ],
                )
              ],
            ),
          );
        }));
  }
}
