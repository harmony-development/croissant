import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text(
          "Login"
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to Staccato',
              style: Theme.of(context).textTheme.headline4,
              textAlign: TextAlign.center,
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Container(
                height: 300.0,
                width: 300.0,
                decoration: BoxDecoration(
                  color: Colors.white
                ),
              ),
            ),
            OutlineButton(
              child: Text(
                "Let's Go",
                style: Theme.of(context).textTheme.button,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}
