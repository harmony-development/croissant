import 'package:croissant/pages/login/homeservers.dart';
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
            ElevatedButton(
              child: Text(
                "Yum",
                style: Theme.of(context).textTheme.button,
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Homeservers()));
              },
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.secondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
