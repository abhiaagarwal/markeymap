import 'package:flutter/material.dart';

class MarkeyMapTheme {
  static ThemeData theme = ThemeData(
    fontFamily: 'Gotham Narrow',
    accentColor: const Color(0xFFFF3333),
    appBarTheme: const AppBarTheme(
      elevation: 0,
    ),
    primaryColor: const Color(0xFF005196),
    scaffoldBackgroundColor: Colors.white,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  static const TextStyle cardHeaderStyle = TextStyle(
    fontFamily: 'Gotham Narrow',
    fontSize: 72,
    fontWeight: FontWeight.w900,
    color: Colors.white,
    letterSpacing: 2,
    shadows: <Shadow>[
      Shadow(
        offset: Offset(0, 6),
      ),
    ],
  );

  static const TextStyle cardListStyle = TextStyle(
    fontSize: 24,
    color: Colors.white,
  );
}
