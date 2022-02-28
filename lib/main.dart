import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:croissant/pages/home/home.dart';
import 'package:croissant/pages/onboarding.dart';
import 'package:croissant/utils/persistent_storage.dart';
import 'package:croissant/state.dart';
import 'package:harmony_sdk/harmony_sdk.dart';

import 'theme/croissant_dark.dart';

void main() => runApp(ChangeNotifierProvider(
      create: (context) => CState(),
      child: const MyApp(),
    ));

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = CroissantDark.theme();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return MaterialApp(
      title: 'Croissant',
      theme: theme,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    loginWithToken(context); // scheduled to execute after build

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loginWithToken(context) async {
    final prefs = await PersistentStorage.get();

    if (prefs.hasSession()) {
      try {
        final session =
            Session(sessionToken: prefs.token, userId: prefs.userId);
        final client = AutoFederateClient(Uri.parse(prefs.host!)).mainClient
          ..setToken(session);
        await client.GetGuildList(GetGuildListRequest());
        await Provider.of<CState>(context, listen: false).initialize(client, prefs.userId!);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),
          (r) => false
        );
        return;
      } catch (e, trace) {
        print(e);
        print(trace);
        print('assuming invalid session; since error handling not updated yet');
        await PersistentStorage.clear();
      }
    }

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Onboarding()),
        (r) => false);
  }
}
