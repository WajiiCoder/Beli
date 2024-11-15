import 'package:flutter/material.dart';

class AppTheme {
  static const Color blue = Color(0xFF4A5DA9);
  static const Color white = Color(0xFFE7E5E2);
  static const Color red = Color(0xFFF11513);

  static ThemeData lightTheme() {
    return ThemeData(
      primaryColor: blue,
      hintColor: blue,
      scaffoldBackgroundColor: white,
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: blue),
        bodyMedium: TextStyle(color: blue),
        displayLarge:
            TextStyle(color: blue, fontSize: 24, fontWeight: FontWeight.bold),
        displayMedium:
            TextStyle(color: blue, fontSize: 20, fontWeight: FontWeight.bold),
        bodySmall: TextStyle(color: red),
      ),
      iconTheme: IconThemeData(
        color: blue,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: blue,
        iconTheme: IconThemeData(color: white),
        titleTextStyle: TextStyle(color: white, fontSize: 20),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: blue,
        textTheme: ButtonTextTheme.primary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: white,
          backgroundColor: blue,
          textStyle: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: blue,
        foregroundColor: white,
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData.dark().copyWith(
      primaryColor: blue,
      hintColor: blue,
      scaffoldBackgroundColor: Colors.black,
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: white),
        bodyMedium: TextStyle(color: white),
        displayLarge:
            TextStyle(color: white, fontSize: 24, fontWeight: FontWeight.bold),
        displayMedium:
            TextStyle(color: white, fontSize: 20, fontWeight: FontWeight.bold),
        bodySmall: TextStyle(color: red),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: blue,
        iconTheme: IconThemeData(color: white),
        titleTextStyle: TextStyle(color: white, fontSize: 20),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: blue,
        textTheme: ButtonTextTheme.primary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: white,
          backgroundColor: blue,
          textStyle: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: blue,
        foregroundColor: white,
      ),
    );
  }
}
