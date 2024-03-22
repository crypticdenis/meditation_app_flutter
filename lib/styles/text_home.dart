import 'package:flutter/material.dart';

ThemeData appTheme() {
  return ThemeData(
    textTheme: TextTheme(
      headline1: TextStyle( // Example styles
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      bodyText1: TextStyle(
        fontSize: 16.0,
        color: Colors.grey[700],
      ),
    ),
  );
}