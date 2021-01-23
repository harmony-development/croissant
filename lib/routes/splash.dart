import 'package:flutter/material.dart';
import 'package:harmony_sdk/harmony_sdk.dart';
import 'package:hive/hive.dart';

import 'hive.dart';
import 'main/main.dart';

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
      final session = Session(cred.token, cred.userId);
      final home = Homeserver(cred.host)..session = session;
      await home.joinedGuilds();
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (context) => Main(home: home,),
      ), (r) => false);
    } catch(e) {
      print(e);
      if (e is GrpcError && e.message == 'invalid-session') {
        print('Invalid session, removing');
        await Hive.box('box').clear();
      }
      Navigator.pushNamedAndRemoveUntil(context, '/onboard', (r) => false);
    }
  }

}