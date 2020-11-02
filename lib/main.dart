import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harmony_sdk/harmony.dart';
import 'package:provider/provider.dart';

import 'routes/auth/auth.dart';
import 'routes/auth/homeservers.dart';
import 'routes/auth/login.dart';
import 'routes/auth/onboarding.dart';
import 'routes/auth/registration.dart';
import 'routes/main/main.dart';
import 'routes/main/state.dart';
import 'routes/splash.dart';
import 'staccato_dark.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MainState(),
      child: MyApp(),
    ),
  );
}

class HomeserverArguments {
  final Homeserver home;

  HomeserverArguments(this.home);
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
      title: 'Staccato',
      theme: theme,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/main': (context) => Main(),
        '/onboard': (context) => Onboarding(title: 'Welcome to Staccato'),
        '/homeservers': (context) => Homeservers(),
        '/auth': (context) => Auth(),
        '/login': (context) => Login(),
        '/registration': (context) => Registration(),
      },
    );
  }
}
