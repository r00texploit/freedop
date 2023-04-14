import 'dart:developer';

import 'package:get/get.dart';
import 'package:today/widgets/theme/constants.dart';
import 'package:today/widgets/theme/style.dart';

import 'theme_preference.dart';
import 'package:flutter/material.dart';

class ThemeModel extends GetxController {
  late bool _isDark;
  late ThemePreferences _preferences;
  bool get isDark => _isDark;
  ThemeData? themeData;
  ThemeModel() {
    _isDark = false;
    _preferences = ThemePreferences();
    getPreferences();
  }
  void setisDark(bool value) {
    _isDark = value;
    _preferences.setTheme(value);
    themeData = value ? darkmode : lightmode;
    log("message:$value");
    update();
    update();
  }

  getPreferences() async {
    _isDark = await _preferences.getTheme();
    update();
  }

  static ThemeData lightmode = ThemeData(
      primaryColor: Color(0xFF3F51B5),
      backgroundColor: Colors.white
      );

  static ThemeData darkmode = ThemeData(
      primaryColor: Colors.black,
      primarySwatch: Colors.blueGrey,
      backgroundColor: Colors.grey);
}
