
import 'package:croissant/state.dart';
import 'package:croissant/theme/croissant_dark.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var page = Column(children: [
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

    if (!Provider.of<CState>(context).isWideScreen) {
      return Scaffold(body: page);
    }

    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height / 6,
        left: MediaQuery.of(context).size.width / 4,
        right: MediaQuery.of(context).size.width / 4,
      ),
      child: SizedBox(
        child: Column(
          children: [
            Container(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height / 1.5,
                  minWidth: MediaQuery.of(context).size.width / 1.5,
                ),
                child: page,
              ),
              decoration: BoxDecoration(
                color: CroissantDark.background,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}