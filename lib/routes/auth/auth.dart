import 'package:flutter/material.dart';
import 'package:harmony_sdk/harmony_sdk.dart';
import 'package:winged_staccato/main.dart';
import 'package:winged_staccato/routes/auth/registration.dart';

class AuthArguments {
  final Homeserver server;

  AuthArguments(this.server);
}

class Auth extends StatelessWidget {
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
                  Navigator.pushNamed(context, '/login', arguments: HomeserverArguments(args.server));
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