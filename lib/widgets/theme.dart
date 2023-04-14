import 'dart:developer';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeColors extends GetxController {
  
   ThemeColors();

  static const Color loginGradientStart = Colors.indigo;
  static const Color loginGradientEnd = Color(0xff004755);

  static const primaryGradient = LinearGradient(
    colors: [loginGradientStart, loginGradientEnd],
    stops: [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const loginbtn = LinearGradient(
    colors: [Color(0xFF42A5F5), Color.fromARGB(15, 42, 197, 244)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );


  
  
  ThemeData lightMode(){
    return ThemeData(
      primaryColor: loginGradientEnd,
      primarySwatch: Colors.indigo,
      backgroundColor: Colors.white
    );
  }
  ThemeData darkMode(){
    return ThemeData(
      primaryColor: Colors.black,
      primarySwatch: Colors.blueGrey,
      backgroundColor: Colors.grey
    );
  }

  Future<ThemeData> currentTheme() async{
  var pref = await SharedPreferences.getInstance();
  var theme = pref.getBool("theme");
  
  return theme! ? darkMode() : lightMode();
}

Future<ThemeData> changeTheme()async {
  var pref = await SharedPreferences.getInstance();
  var theme = pref.getBool("theme");
  log(theme!? "dark Theme": "light Theme") ;
  pref.setBool("theme",true) ;
  return !theme ? darkMode() : lightMode();
}
}
