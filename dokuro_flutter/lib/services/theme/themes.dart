import 'package:flutter/material.dart';

Color bgLight = Colors.black12;
Color bgDark = const Color(0xFF1a1a1a);
Color mainBlack = const Color(0xFF262626);
Color fbBlue = const Color(0xFF2D88FF);
Color mainGrey = const Color(0xFF505050);

class Themes {
  static final light = ThemeData.light().copyWith(
    backgroundColor: bgLight,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
    ),
    //primaryColor: Colors.lightBlue,
  );
  static final dark = ThemeData.dark().copyWith(
    backgroundColor: bgDark,
    cardColor: mainBlack,
  );
}
