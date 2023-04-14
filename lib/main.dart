import 'dart:io';
import 'dart:ui' as ui;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:today/controller/auth_controller.dart';
import 'package:today/pages/home.dart';
import 'package:today/screens/login.dart';
import 'package:today/widgets/theme.dart';
import 'package:today/widgets/theme/constants.dart';
import 'package:today/widgets/theme/style.dart';
import 'package:today/widgets/theme/theme_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Map<Permission, PermissionStatus> statuses = await [
    Permission.accessMediaLocation,
    Permission.manageExternalStorage,
    Permission.storage,
  ].request();
  Get.put(AuthController());
  Get.put(ThemeColors());
  Get.put(ThemeModel());
  var dir = Directory("storage/emulated/0/.freedop").create(recursive: true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final AuthController controller = Get.put(AuthController());
  var theme = Get.find<ThemeModel>();
  // var cur = theme.currentTheme();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeModel>(builder: ((controller) {
      return GetMaterialApp(
          textDirection: ui.TextDirection.ltr,
          title: '',
          debugShowCheckedModeBanner: false,
          theme: controller.themeData,
          home: SplashScreenView(
            navigateRoute: LoginScreen(),
            backgroundColor: Colors.indigo,
            duration: 5000,
            imageSize: 300,
            imageSrc: 'assets/images/logo.png',
            text: 'Free DOP-Domain Of Privacy',
            textType: TextType.TyperAnimatedText,
            textStyle: const TextStyle(fontSize: 30.0, color: Colors.white),
          ));
      // }));
    }));
  }
}
