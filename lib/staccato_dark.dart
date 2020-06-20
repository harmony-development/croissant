import 'package:flutter/material.dart';

class StaccatoDark {
  static const MaterialColor background =
      MaterialColor(backgroundPrimary, <int, Color>{
    50: Color(0xFFE4E4E7),
    100: Color(0xFFBCBCC2),
    200: Color(0xFF8F8F99),
    300: Color(0xFF626270),
    400: Color(0xFF414052),
    500: Color(backgroundPrimary),
    600: Color(0xFF1B1A2E),
    700: Color(0xFF171627),
    800: Color(0xFF121220),
    900: Color(0xFF0A0A14),
  });
  static const int backgroundPrimary = 0xFF1F1E33;

  static const MaterialColor accent =
      MaterialColor(backgroundAccent, <int, Color>{
    100: Color(0xFF5858FF),
    200: Color(backgroundAccent),
    400: Color(0xFF0000F1),
    700: Color(0xFF0000D7),
  });
  static const int backgroundAccent = 0xFF2525FF;
}
