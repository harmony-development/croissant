import 'package:flutter/material.dart';

class Onboarding extends StatelessWidget {
  Onboarding({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to Staccato',
              style: Theme.of(context).textTheme.headline4,
              textAlign: TextAlign.center,
            ),
            Text(
              'Please select a server',
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            Container(),
            RaisedButton(
              child: Text(
                "Let's Go",
                style: Theme.of(context).textTheme.button,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/homeservers');
              },
              color: Theme.of(context).colorScheme.secondary,
            ),
          ],
        ),
      ),
    );
  }
}
