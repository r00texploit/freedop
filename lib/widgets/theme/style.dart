import 'package:flutter/material.dart';
import 'package:today/widgets/theme.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    var theme = ThemeColors();
    return ThemeData(
      primarySwatch: isDarkTheme ? Colors.blueGrey : Colors.indigo , 
      primaryColor: isDarkTheme ? Colors.grey : ThemeColors.loginGradientEnd,
      backgroundColor: isDarkTheme ? Colors.black : const Color(0xffF1F5FB),
    );
  }
  
  

}
