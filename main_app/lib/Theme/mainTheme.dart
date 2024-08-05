import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum ThemeStyle{dark, light}

// DARK VERSION
Color primaryDark = const Color.fromARGB(255, 3, 18, 27);
Color secondaryDark = const Color.fromARGB(255,20, 57, 81);
Color btnDark = const Color.fromARGB(255, 255, 213, 109);
Color textDark = const Color.fromARGB(255, 255, 255, 255);
Color subTextDark = Colors.grey.shade600;
ThemeData AppThemeDark = ThemeData.dark().copyWith(
  primaryColor: primaryDark,
  cardColor: btnDark,           // button color, <edit profile text>
  secondaryHeaderColor: secondaryDark,  // use for list note of card 
  highlightColor: textDark,       // Use for bio container(such as name, bio, mail box)
  canvasColor: textDark,          // use for overal text 
  textTheme: TextTheme(
    // this text is for text of button 
    labelMedium: GoogleFonts.sofiaSansSemiCondensed(
      fontWeight: FontWeight.w600,
      letterSpacing: 1.2,
      fontSize: 14,
      color: primaryDark,
    ),
    labelSmall: GoogleFonts.sofiaSansSemiCondensed(
      fontWeight: FontWeight.w600,
      letterSpacing: 1.1,
      fontSize: 16,
      color: btnDark,
    ),
    labelLarge: GoogleFonts.sofiaSansSemiCondensed(
      color: subTextDark,
      fontSize: 16,
    ),
    headlineLarge: GoogleFonts.sofiaSansSemiCondensed(
      fontSize: 30,
      color: textDark,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    ),
    headlineMedium: GoogleFonts.sofiaSansSemiCondensed(
      fontSize: 25,
      color: textDark,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5
    ),
    bodyMedium: GoogleFonts.sofiaSansSemiCondensed(
      fontWeight: FontWeight.w500,
      letterSpacing: 1.2,
      fontSize: 14,
      color: textDark,
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
    ),
    
    displayMedium: TextStyle(
      color: Color.fromARGB(255, 80, 79, 79),
    )
  ),
  
);


// LIGHT VERSION
Color primaryLight =  const Color.fromARGB(255, 255, 247, 236);
Color secondaryLight = const Color.fromARGB(255, 214, 130, 32);
Color btnLight = const Color.fromARGB(255, 52, 207, 199);
Color textLight = const Color.fromARGB(255, 214, 130, 128);
Color boxColor = const Color.fromARGB(255, 255, 227, 179);
Color subTextLight = Colors.black;
ThemeData AppThemeLight = ThemeData.light().copyWith(
  primaryColor: primaryLight,
  secondaryHeaderColor: secondaryLight,
  highlightColor: boxColor,
  canvasColor: secondaryLight,
  cardColor: btnLight,
  
  textTheme: TextTheme(
    // this text is for text of button 
    labelMedium: GoogleFonts.sofiaSansSemiCondensed(
      fontWeight: FontWeight.w600,
      letterSpacing: 1.2,
      fontSize: 14,
      color: primaryDark,
    ),
    labelSmall: GoogleFonts.sofiaSansSemiCondensed(
      fontWeight: FontWeight.w600,
      letterSpacing: 1.1,
      fontSize: 16,
      color: btnLight,
    ),
    labelLarge: GoogleFonts.sofiaSansSemiCondensed(
      color: subTextLight,
      fontSize: 16,
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
    headlineMedium: GoogleFonts.sofiaSansSemiCondensed(     // use in new note screen
      fontSize: 25,
      color: secondaryLight,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5
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
    ),
    displayMedium: TextStyle(
      color: Colors.black,
    )
  ),
  );

class ThemeModeProvider with ChangeNotifier{
  ThemeData _themeMode = AppThemeLight;
  ThemeData get themeMode => _themeMode;
  void updateThemeMode(ThemeData update){
    _themeMode = update;
    notifyListeners();
  }
}

  