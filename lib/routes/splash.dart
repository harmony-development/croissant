import 'package:flutter/material.dart';
import 'package:harmony_sdk/harmony.dart';
import 'package:hive/hive.dart';
import 'package:winged_staccato/main.dart';

import 'hive.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    loginWithToken(context); // scheduled to execute after build

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
      final session = SSession(cred.token, cred.userId);
      final home = Homeserver(cred.host)..session = session;
      Navigator.pushNamedAndRemoveUntil(context, '/main', (r) => false, arguments: HomeserverArguments(home));
    } catch(e) {
      print(e);
      Navigator.pushNamedAndRemoveUntil(context, '/onboard', (r) => false);
    }
  }

}