import 'package:flutter/material.dart';
import 'package:harmony_sdk/harmony_sdk.dart';
import 'package:provider/provider.dart';
import 'package:winged_staccato/routes/main/member_item.dart';

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
          Container(
            height: 60,
            child: DrawerHeader(
              child: Text('Members'),
              decoration: BoxDecoration(
                color: Colors.red,
              ),
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
        return MemberItem(m);
      });
  }

  Future<void> getMembers(Channel channel) => channel.listMembers().then((value) =>
    setState(() { _members = value; }));

}