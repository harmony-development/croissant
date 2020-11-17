import 'package:flutter/material.dart';
import 'package:harmony_sdk/harmony_sdk.dart';
import 'package:winged_staccato/routes/auth/auth.dart';

class Homeservers extends StatefulWidget {
  Homeservers({Key key}) : super(key: key);

  @override
  _HomeserversState createState() => _HomeserversState();
}

class _HomeserversState extends State<Homeservers> {
  final serverController = TextEditingController(text: "192.168.0.69");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text(
          "Homeserver"
        ),
      ),
      body: Builder(
          builder: (context) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Enter homeserver address",
                  style: Theme.of(context).textTheme.headline4,
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Address',
                    ),
                    controller: serverController,
                  ),
                ),
                OutlineButton(
                  child: Text("Select"),
                  onPressed: () => Navigator.pushNamed(context, '/auth', arguments: AuthArguments(Homeserver(serverController.text))),
                )
              ],
            ),
          )
      )
    );
  }
}
