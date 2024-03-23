import 'package:flutter/material.dart';

ThemeData appTheme() {
  return ThemeData(
    textTheme: TextTheme(
      displayLarge: const TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      bodyLarge: TextStyle(
        fontSize: 16.0,
        color: Colors.grey[700],
      ),
    ),
  );
}
