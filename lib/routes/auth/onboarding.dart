import 'package:flutter/material.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(image: AssetImage('assets/logo128.png')),
            const SizedBox(height: 20,),
            Text(
              'Welcome to Croissant',
              style: Theme.of(context).textTheme.headline4,
              textAlign: TextAlign.center,
            ),
            Text(
              'Please select a homeserver',
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            Container(),
            RaisedButton(
              child: Text(
                "Yum",
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
