import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// DARK VERSION
Color primaryDark = Color.fromARGB(255, 3, 18, 27);
Color secondaryDark = Color.fromARGB(255,20, 57, 81);
Color btnDark = Color.fromARGB(255, 255, 213, 109);
Color textDark = Color.fromARGB(255, 255, 255, 255);
ThemeData AppThemeDark = ThemeData.dark().copyWith(primaryColor: primaryDark);


// LIGHT VERSION
Color primaryLight =  Color.fromARGB(255, 255, 247, 236);
Color secondaryLight = Color.fromARGB(255, 214, 130, 32);
Color btnLight = Color.fromARGB(255, 52, 207, 199);
Color textLight = Color.fromARGB(255, 214, 130, 128);
Color boxColor = Color.fromARGB(255, 255, 227, 179);
ThemeData AppThemeLight = ThemeData.light().copyWith(
  primaryColor: primaryLight,
  textTheme: TextTheme(
    bodyMedium: TextStyle(
      fontWeight: FontWeight.w500,
      letterSpacing: 1.2,
      fontSize: 14,
      color: Colors.white,
    )
  ),
  cardColor: btnLight,
  );