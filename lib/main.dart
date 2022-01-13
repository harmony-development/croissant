import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'routes/auth/homeservers.dart';
import 'routes/auth/onboarding.dart';
import 'routes/main/state.dart';
import 'routes/splash.dart';
import 'croissant_dark.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MainState(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = ThemeData.dark().copyWith(
        backgroundColor: CroissantDark.background,
        scaffoldBackgroundColor: CroissantDark.background,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: const ColorScheme.dark()
            .copyWith(primary: Colors.deepPurple, secondary: Colors.pink),
        brightness: Brightness.dark);
    theme = theme.copyWith(
        textTheme: GoogleFonts.manropeTextTheme(theme.textTheme),
        accentTextTheme: GoogleFonts.manropeTextTheme(theme.accentTextTheme),
        primaryTextTheme: GoogleFonts.manropeTextTheme(theme.primaryTextTheme));

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return MaterialApp(
      title: 'Croissant',
      theme: theme,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
//        '/main': (context) => Main(),
        '/onboard': (context) => Onboarding(title: 'Welcome to Croissant'),
        '/homeservers': (context) => Homeservers(),
//        '/auth': (context) => Auth(),
      },
    );
  }
}
