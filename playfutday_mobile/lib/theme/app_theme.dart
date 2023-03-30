import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Colors.white;
  static const Color transparent = Colors.transparent;
  static final ThemeData darkTheme = ThemeData.dark().copyWith(
      primaryColor: Colors.black12,
      appBarTheme: const AppBarTheme(
        color: Colors.black12,
        elevation: 0.0,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(
          color: Color.fromARGB(255, 83, 83, 83),
          fontSize: 16,
        ),
        fillColor: Colors.white,
        focusColor: Colors.black,
        floatingLabelStyle: TextStyle(
          color: Color.fromARGB(255, 83, 83, 83),
          fontSize: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 0, 38, 100),
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.all(Radius.circular(0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 0, 38, 100),
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.all(Radius.circular(0)),
        ),
      ),
      cardTheme: const CardTheme(color: primary, elevation: 0),
      elevatedButtonTheme: const ElevatedButtonThemeData(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll(Color.fromARGB(255, 0, 38, 100)))));
}
