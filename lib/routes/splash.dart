import 'package:croissant/routes/utils.dart';
import 'package:flutter/material.dart';
import 'package:harmony_sdk/harmony_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main/main.dart';
import 'package:fixnum/fixnum.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    loginWithToken(context); // scheduled to execute after build

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  Future<void> loginWithToken(context) async {
    final prefs = await PersistentStorage.get();

    if (prefs.hasSession()) {
      try {
        final session = Session(sessionToken: prefs.token, userId: prefs.userId);
        final client = AutoFederateClient(Uri.parse(prefs.host!)).mainClient..setToken(session);
        await client.GetGuildList(GetGuildListRequest());
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder: (context) => Main(client: client),
        ), (r) => false);
        return;
      } catch(e) {
        print(e);
        print('assuming invalid session; since error handling not updated yet');
        await PersistentStorage.clear();
      }
    }

    Navigator.pushNamedAndRemoveUntil(context, '/onboard', (r) => false);
  }
}