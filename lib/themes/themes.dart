import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class MyThemes {
  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(
        onTertiary: Colors.black, primary: HexColor("#2c5436")),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.white,
    ), //0e2723
    primaryColor: HexColor("#123524"),
    inputDecorationTheme: InputDecorationTheme(
      focusColor: HexColor("#123524"),
    ),
    primarySwatch: Colors.green,
  );
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Color.fromARGB(255, 37, 37, 37),
    colorScheme: ColorScheme.dark(onTertiary: Colors.white),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.white,
    ),
    primaryColor: Color.fromARGB(255, 19, 19, 19),
    primarySwatch: Colors.grey,
  );
}
