import 'package:flutter/material.dart';
import 'package:harmony_sdk/harmony.dart';
import 'package:provider/provider.dart';

import 'state.dart';

class MembersDrawer extends StatefulWidget {

  @override
  _MembersState createState() => _MembersState();

}

class _MembersState extends State<MembersDrawer> {

  List<User> _members;

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MainState>(context);
    if (_members == null) {
      getMembers(state.selectedChannel);
      return Drawer(
          child: Center(
              child: CircularProgressIndicator()
          )
      );
    }
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Text('Member Header'),
            decoration: BoxDecoration(
              color: Colors.red,
            ),
          ),
          buildMemberList(),
        ],
      ),
    );
  }

  Widget buildMemberList() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: _members == null ? 0 : _members.length,
        itemBuilder: (BuildContext context, int index) {
          User m = _members[index];
          return ListTile(
                title: FutureBuilder(
                  future: m.name,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data);
                    }
                    return Text(m.id.toString());
                  },
                ),
                onTap: () {},
          );
        });
  }

  Future<void> getMembers(Channel channel) => channel.listMembers().then((value) =>
    setState(() { _members = value; }));

}