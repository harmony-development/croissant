import 'package:flutter/material.dart';
import 'package:harmony_sdk/harmony_sdk.dart';
import 'auth.dart';

class Homeservers extends StatelessWidget {
  Homeservers({Key? key}) : super(key: key);

  final serverController = TextEditingController(text: "http://192.168.0.121:2289");
  // final serverController = TextEditingController(text: "https://chat.harmonyapp.io:2289");

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
              ElevatedButton(
                child: const Text("Select"),
                onPressed: () {
                    Navigator.push(context,
                    MaterialPageRoute(
                      // todo: put this in state
                      builder: (context) => Auth(client: AutoFederateClient(Uri.parse(serverController.text)).mainClient),
                    )
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.secondary),
                ),
              )
            ],
          ),
        )
      )
    );
  }
}
