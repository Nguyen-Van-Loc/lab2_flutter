import 'package:flutter/material.dart';

class AppTheme {
  static final light=ThemeData(
     scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      color: Colors.teal,
      iconTheme: IconThemeData(
        color: Colors.white,
      )
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        color: Colors.black,
      )
    )
  );
  static final dark=ThemeData(
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: const AppBarTheme(
          color: Colors.black,
          iconTheme: IconThemeData(
            color: Colors.white,
          )
      ),
      textTheme: const TextTheme(
          bodyMedium: TextStyle(
            color: Colors.white,
          )
      )
  );
}