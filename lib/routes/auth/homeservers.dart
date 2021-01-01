import 'package:flutter/material.dart';
import 'package:harmony_sdk/harmony_sdk.dart';
import 'auth.dart';

class Homeservers extends StatefulWidget {
  @override
  _HomeserversState createState() => _HomeserversState();
}

class _HomeserversState extends State<Homeservers> {
  final serverController = TextEditingController(text: "chat.harmonyapp.io");

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
              RaisedButton(
                child: Text("Select"),
                onPressed: () => Navigator.push(context,
                  MaterialPageRoute(
                    builder: (context) => Auth(home: Homeserver(serverController.text),),
                  )
                ),
                color: Theme.of(context).colorScheme.secondary,
              )
            ],
          ),
        )
      )
    );
  }
}
