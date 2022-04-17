
import 'package:croissant/state.dart';
import 'package:flutter/material.dart';
import 'package:harmony_sdk/harmony_sdk.dart';
import 'package:provider/provider.dart';

class AddGuildPage extends StatefulWidget {
  const AddGuildPage({Key? key}) : super(key: key);

  @override
  AddGuildPageState createState() => AddGuildPageState();
}

class AddGuildPageState extends State<AddGuildPage> {
  final TextEditingController _joinController = TextEditingController();
  final TextEditingController _createController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      AppBar(title: const Text("Add Guild")),
      Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                const Text("Join Guild:"),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    constraints: const BoxConstraints(
                      maxWidth: 200,
                      minHeight: 45,
                    ),
                    child: Material(
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: "Invite ID",
                        ),
                        obscureText: false,
                        controller: _joinController,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    var client = Provider.of<CState>(context, listen: false).client;
                    await client.JoinGuild(JoinGuildRequest(inviteId: _joinController.text.trim()));
                    Navigator.pop(context);
                  },
                  child: const Text("Join"),
                ),
              ],
            ),
            SizedBox.fromSize(size: const Size(0, 10),),
            Row(
              children: [
                const Text("Create Guild:"),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    constraints: const BoxConstraints(
                      maxWidth: 200,
                      minHeight: 45,
                    ),
                    child: Material(
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: "New Guild Name",
                        ),
                        obscureText: false,
                        controller: _createController,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    var client = Provider.of<CState>(context, listen: false).client;
                    await client.CreateGuild(CreateGuildRequest(name: _createController.text.trim()));
                    Navigator.pop(context);
                  },
                  child: const Text("Create"),
                ),
              ],
            ),
          ],
        )
      ),
    ]);
  }
}