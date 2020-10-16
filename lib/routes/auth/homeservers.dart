import 'package:flutter/material.dart';
import 'package:harmony_sdk/harmony.dart';
import 'package:winged_staccato/routes/auth/auth.dart';

class Homeservers extends StatefulWidget {
  Homeservers({Key key}) : super(key: key);

  @override
  _HomeserversState createState() => _HomeserversState();
}

class _HomeserversState extends State<Homeservers> {
  @override
  Widget build(BuildContext context) {
    List<Homeserver> homeservers = List();
    homeservers.add(Homeserver("localhost"));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text(
          "Select a homeserver"
        ),
      ),
      body: ListView.builder(
        itemCount: homeservers.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(
              homeservers[index].host
            ),
            onTap: () => Navigator.pushNamed(context, '/auth', arguments: AuthArguments(homeservers[index])),
          );
        },
      ),
    );
  }
}
