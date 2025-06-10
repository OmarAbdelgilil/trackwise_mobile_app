import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:track_wise_mobile_app/utils/colors_manager.dart';

ThemeData get lightTheme => ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.roboto().fontFamily,
      brightness: Brightness.light,
      scaffoldBackgroundColor: ColorsManager.lightBackground,
      primaryColor: ColorsManager.lightPrimary,
      appBarTheme: const AppBarTheme(
        backgroundColor: ColorsManager.lightBackground,
        foregroundColor: Colors.black,
      ),
      bottomNavigationBarTheme:
          BottomNavigationBarThemeData(backgroundColor: Colors.blueGrey[100]),
      iconTheme: const IconThemeData(color: Colors.black),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.black),
        bodyMedium: TextStyle(color: Colors.black),
        bodySmall: TextStyle(color: Colors.black),
        displayLarge: TextStyle(color: Colors.black),
        displayMedium: TextStyle(color: Colors.black),
        displaySmall: TextStyle(color: Colors.black),
        headlineLarge: TextStyle(color: Colors.black),
        headlineMedium: TextStyle(color: Colors.black),
        headlineSmall: TextStyle(color: Colors.black),
        labelLarge: TextStyle(color: Colors.black),
        labelMedium: TextStyle(color: Colors.black),
        titleLarge: TextStyle(color: Colors.black),
        titleMedium: TextStyle(color: Colors.black),
        titleSmall: TextStyle(color: Colors.black),
      ),
    );

ThemeData get darkTheme => ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.roboto().fontFamily,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: ColorsManager.darkBackground,
      primaryColor: ColorsManager.darkPrimary,
      appBarTheme: const AppBarTheme(
        backgroundColor: ColorsManager.darkBackground,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBarTheme:
          const BottomNavigationBarThemeData(backgroundColor: Colors.black),
      iconTheme: const IconThemeData(color: Colors.white),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
        bodySmall: TextStyle(color: Colors.white),
        displayLarge: TextStyle(color: Colors.white),
        displayMedium: TextStyle(color: Colors.white),
        displaySmall: TextStyle(color: Colors.white),
        headlineLarge: TextStyle(color: Colors.white),
        headlineMedium: TextStyle(color: Colors.white),
        headlineSmall: TextStyle(color: Colors.white),
        labelLarge: TextStyle(color: Colors.white),
        labelMedium: TextStyle(color: Colors.white),
        titleLarge: TextStyle(color: Colors.white),
        titleMedium: TextStyle(color: Colors.white),
        titleSmall: TextStyle(color: Colors.white),
      ),
    );

Color containerColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? ColorsManager.darkContainer
      : const Color.fromARGB(115, 207, 216, 220);
}

Color barChartLabelColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? Colors.white
      : Colors.blueGrey[100]!;
}
