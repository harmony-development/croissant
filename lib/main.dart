import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'routes/onboarding.dart';
import 'routes/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var theme = ThemeData.dark().copyWith(
      primaryColor: Color(0xFF8BCEF2),
      primaryColorBrightness: Brightness.light,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
    theme = theme.copyWith(
      textTheme: GoogleFonts.manropeTextTheme(theme.textTheme),
      accentTextTheme: GoogleFonts.manropeTextTheme(theme.accentTextTheme),
      primaryTextTheme: GoogleFonts.manropeTextTheme(theme.primaryTextTheme)
    );

    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme,
      initialRoute: '/',
      routes: {
        '/': (context) => Onboarding(title: 'Welcome to Staccato'),
        '/login': (context) => Login(),
      },
    );
  }
}