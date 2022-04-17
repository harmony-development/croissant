
import 'package:croissant/state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      AppBar(title: const Text("Settings")),
      Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                const Text("Logged in as "),
                Text(
                  Provider.of<CState>(context).ownProfile.userName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text("@"),
                Text(
                  Provider.of<CState>(context).client.server.host,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        )
      ),
    ]);
  }
}