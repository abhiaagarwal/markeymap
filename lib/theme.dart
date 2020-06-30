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

  static const TextStyle appBarStyle = TextStyle(
    fontFamily: 'Gotham Narrow',
    fontWeight: FontWeight.w900,
    color: Colors.white,
    fontSize: 52,
    letterSpacing: 2,
    shadows: <Shadow>[
      Shadow(
        color: Color(0xFF005196),
        offset: Offset(0, 4),
        blurRadius: 2.0,
      ),
    ]
  );

  static const TextStyle welcomeHeaderStyle = TextStyle(
    color: Colors.white,
    fontFamily: 'Gotham Narrow',
    fontWeight: FontWeight.w900,
    fontSize: 96,
    fontStyle: FontStyle.italic,
    letterSpacing: 2,
    shadows: <Shadow>[
      Shadow(
        blurRadius: 2.0,
        color: Color(0xFF00044C),
        offset: Offset(4, 4),
      ),
    ],
  );

  static const TextStyle cardHeaderStyle = TextStyle(
    fontFamily: 'Gotham Narrow',
    fontSize: 64,
    fontWeight: FontWeight.w900,
    color: Colors.white,
    letterSpacing: 2,
    shadows: <Shadow>[
      Shadow(
        blurRadius: 2.0,
        color: Color(0xFF00044C),
        offset: Offset(0, 4),
      ),
    ],
  );

  static const TextStyle cardListStyle = TextStyle(
    fontSize: 20,
    color: Colors.white,
  );
}
