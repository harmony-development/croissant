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
  int _refreshCount;

  @override
  void initState() {
    super.initState();
    _refreshCount = 0;
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MainState>(context);
    if (state.selectedGuildMembers == null) {
      state.updateMembers();
      return Drawer(
        child: Center(
          child: CircularProgressIndicator()
        )
      );
    }
    List<User> members = state.selectedGuildMembers;

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
          ListView.builder(
            shrinkWrap: true,
            itemCount: members == null ? 0 : members.length,
            itemBuilder: (BuildContext context, int index) {
              return MemberItem(index);
            }
          ),
        ],
      ),
    );
  }

  Future<void> getMembers(Guild guild) async {
    await guild.refresh();
    setState(() {
      _refreshCount += 1;
    });
  }

}