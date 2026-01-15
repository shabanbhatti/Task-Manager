import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.black,
  primaryColor: Colors.white,
  cardTheme: CardThemeData(
    color: Colors.grey.withAlpha(100),
    shadowColor: Colors.grey,
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Color.fromARGB(255, 128, 128, 128),
    selectionColor: Colors.grey.withAlpha(100),
    selectionHandleColor: Color.fromARGB(255, 128, 128, 128),
  ),
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: Colors.black,
    modalBarrierColor: Colors.grey.withAlpha(50),
  ),
);

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  primaryColor: Colors.black,
  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 50,
    shadowColor: Colors.grey,
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Color.fromARGB(255, 128, 128, 128),
    selectionColor: Colors.grey.withAlpha(100),
    selectionHandleColor: Color.fromARGB(255, 128, 128, 128),
  ),
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: Colors.white,
    modalBarrierColor: Colors.black.withAlpha(100),
  ),
);
