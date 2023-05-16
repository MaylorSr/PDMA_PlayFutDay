import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Colors.white;
  static const Color blackSolid = Colors.black;
  static const Color transparent = Colors.transparent;
  static const Color grey = Colors.grey;
  static const Color successEvent = Color.fromARGB(255, 6, 121, 9);
  //**STYLES TITLE GOOGLE FONTS */

  static TextStyle tittleApp = GoogleFonts.adamina(
    decorationThickness: 25.0,
    fontWeight: FontWeight.w600,
    fontSize: 23,
  );

  static TextStyle nameUsersStyle = GoogleFonts.lora(
      fontWeight: FontWeight.w400, fontSize: 13, color: AppTheme.primary);

  static TextStyle errorMessageStyle = GoogleFonts.alata(
    fontWeight: FontWeight.w400,
    fontSize: 20,
  );

  static TextStyle deleteSure =
      GoogleFonts.alata(fontWeight: FontWeight.w400, fontSize: 18);

  static TextStyle deleteSured = GoogleFonts.alata(
      fontWeight: FontWeight.w400, fontSize: 18, color: Colors.red);

  //*COST HEIGHT */

  static double mediumHeight = 50.0;

  static double minHeight = 5.0;

  //* PADDING */
  static double minPadding = 5.0;

  static double mediumPadding = 15.0;

  //* MARGIN */

  static double mediumMargin = 25.0;
  static double maxMargin = 50.0;
  

  //* theme data buttom, card...*/

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
        backgroundColor: MaterialStatePropertyAll(
          Color.fromARGB(255, 0, 38, 100),
        ),
      ),
    ),
  );
}
