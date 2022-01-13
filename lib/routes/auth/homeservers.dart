import 'dart:ffi';

import 'package:croissant/routes/main/main.dart';
import 'package:flutter/material.dart';
import 'package:harmony_sdk/harmony_sdk.dart';
import 'auth.dart';
import 'package:fixnum/fixnum.dart';

class Homeservers extends StatefulWidget {
  @override
  _HomeserversState createState() => _HomeserversState();
}

class _HomeserversState extends State<Homeservers> {
  final serverController = TextEditingController(text: "https://chat.harmonyapp.io:2289");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: const Text("Homeserver"),
      ),
      body: Builder(
        builder: (context) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Enter homeserver address",
                style: Theme.of(context).textTheme.headline4,
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 16.0),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Address',
                  ),
                  controller: serverController,
                ),
              ),
              RaisedButton(
                child: const Text("Select"),
                onPressed: () {
                    Navigator.push(context,
                    MaterialPageRoute(
                      // todo: put this in state
                      builder: (context) => Auth(client: AutoFederateClient(Uri.parse(serverController.text)).mainClient),
                    )
                  );
                },
                color: Theme.of(context).colorScheme.secondary,
              )
            ],
          ),
        )
      )
    );
  }
}
