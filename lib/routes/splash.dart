import 'package:flutter/material.dart';
import 'package:harmony_sdk/harmony_sdk.dart';
import 'package:hive/hive.dart';

import 'hive.dart';
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
    try {
      if (!Hive.isBoxOpen('box')) {
        await HiveUtils.superInit();
      }

      Credentials cred = Hive.box('box').getAt(0);
      final session = Session(sessionToken: cred.token, userId: Int64(cred.userId));
      final client = AutoFederateClient(Uri.parse(cred.host)).mainClient..setToken(session);
      await client.GetGuildList(GetGuildListRequest());
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => Main(client: client),
      ));
    } catch(e) {
      print(e);
      print('assuming invalid session; since error handling not updated yet');
      await Hive.box('box').clear();
      Navigator.pushNamedAndRemoveUntil(context, '/onboard', (r) => false);
    }
  }

}