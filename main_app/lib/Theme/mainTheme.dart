import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum ThemeStyle{dark, light}

// DARK VERSION
Color primaryDark = Color.fromARGB(255, 3, 18, 27);
Color secondaryDark = Color.fromARGB(255,20, 57, 81);
Color btnDark = Color.fromARGB(255, 255, 213, 109);
Color textDark = Color.fromARGB(255, 255, 255, 255);
ThemeData AppThemeDark = ThemeData.dark().copyWith(
  primaryColor: primaryDark,
  textTheme: TextTheme(
    // this text is for text of button 
    labelMedium: GoogleFonts.sofiaSansSemiCondensed(
      fontWeight: FontWeight.w600,
      letterSpacing: 1.2,
      fontSize: 14,
      color: primaryDark,
    ),
    bodyMedium: GoogleFonts.sofiaSansSemiCondensed(
      fontWeight: FontWeight.w500,
      letterSpacing: 1.2,
      fontSize: 14,
      color: textDark,
    ),
    headlineLarge: GoogleFonts.sofiaSansSemiCondensed(
      fontSize: 30,
      color: textDark,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    ),
    bodyLarge: GoogleFonts.sofiaSansSemiCondensed(
      fontSize: 15,
      color: textDark,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5
    ),
    bodySmall: GoogleFonts.sofiaSansSemiCondensed(
      color: textDark,
      fontSize: 20,
    )
  ),
  cardColor: btnDark,
  
  secondaryHeaderColor: Colors.white, 
);


// LIGHT VERSION
Color primaryLight =  Color.fromARGB(255, 255, 247, 236);
Color secondaryLight = Color.fromARGB(255, 214, 130, 32);
Color btnLight = Color.fromARGB(255, 52, 207, 199);
Color textLight = Color.fromARGB(255, 214, 130, 128);
Color boxColor = Color.fromARGB(255, 255, 227, 179);
ThemeData AppThemeLight = ThemeData.light().copyWith(
  primaryColor: primaryLight,
  secondaryHeaderColor: secondaryLight,
  textTheme: TextTheme(
    // this text is for text of button 
    labelMedium: GoogleFonts.sofiaSansSemiCondensed(
      fontWeight: FontWeight.w600,
      letterSpacing: 1.2,
      fontSize: 14,
      color: primaryDark,
    ),
    bodyMedium: GoogleFonts.sofiaSansSemiCondensed(
      fontWeight: FontWeight.w500,
      letterSpacing: 1.2,
      fontSize: 14,
      color: Colors.white,
    ),
    headlineLarge: GoogleFonts.sofiaSansSemiCondensed(
      fontSize: 30,
      color: secondaryLight,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    ),
    bodyLarge: GoogleFonts.sofiaSansSemiCondensed(
      fontSize: 15,
      color: secondaryLight,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5
    ),
    bodySmall: GoogleFonts.sofiaSansSemiCondensed(
      color: secondaryLight,
      fontSize: 20,
    )
  ),
  cardColor: btnLight,
  );

class ThemeModeProvider with ChangeNotifier{
  ThemeData _themeMode = AppThemeLight;
  ThemeData get themeMode => _themeMode;
  void updateThemeMode(ThemeData update){
    _themeMode = update;
    notifyListeners();
  }
}

  