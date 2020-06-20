import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:winged_staccato/staccato_dark.dart';

import 'routes/onboarding.dart';
import 'routes/homeservers.dart';
import 'routes/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var theme = ThemeData.dark().copyWith(
        backgroundColor: StaccatoDark.background,
        scaffoldBackgroundColor: StaccatoDark.background,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.dark()
            .copyWith(primary: Colors.deepPurple, secondary: Colors.pink),
        brightness: Brightness.dark);
    theme = theme.copyWith(
        textTheme: GoogleFonts.manropeTextTheme(theme.textTheme),
        accentTextTheme: GoogleFonts.manropeTextTheme(theme.accentTextTheme),
        primaryTextTheme: GoogleFonts.manropeTextTheme(theme.primaryTextTheme));

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme,
      initialRoute: '/',
      routes: {
        '/': (context) => Onboarding(title: 'Welcome to Staccato'),
        '/homeservers': (context) => Homeservers(),
        '/login': (context) => Login(),
      },
    );
  }
}
