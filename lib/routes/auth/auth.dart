import 'package:flutter/material.dart';
import 'package:harmony_sdk/harmony.dart';
import 'package:winged_staccato/routes/auth/registration.dart';

import 'login.dart';

class AuthArguments {
  final Homeserver server;

  AuthArguments(this.server);
}

class Auth extends StatefulWidget {
  Auth({Key key}) : super(key: key);

  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  @override
  Widget build(BuildContext context) {
    final AuthArguments args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text(
            "Auth method"
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Choose auth method',
              style: Theme.of(context).textTheme.headline4,
              textAlign: TextAlign.center,
            ),
            Container(),
            RaisedButton(
              child: Text(
                "Login",
                style: Theme.of(context).textTheme.button,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/login', arguments: LoginArguments(args.server));
              },
              color: Theme.of(context).colorScheme.secondary,
            ),
            Container(),
            RaisedButton(
              child: Text(
                "Register",
                style: Theme.of(context).textTheme.button,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/registration', arguments: RegistrationArguments(args.server));
              },
              color: Theme.of(context).colorScheme.secondary,
            ),
          ],
        )
      ),
    );
  }
}