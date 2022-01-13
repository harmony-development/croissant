import 'package:flutter/material.dart';
import 'package:harmony_sdk/harmony_sdk.dart';
import 'package:provider/provider.dart';
import 'package:croissant/routes/main/member_item.dart';

import 'state.dart';

class MembersDrawer extends StatefulWidget {
  @override
  _MembersState createState() => _MembersState();
}

class _MembersState extends State<MembersDrawer> {
  // todo: what is the point of this?
  late int _refreshCount;

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
      return const Drawer(
        child: Center(
          child: CircularProgressIndicator()
        )
      );
    }
    Map<int,Profile> members = state.selectedGuildMembers;

    return Drawer(
      child: ListView(
        children:[
          Container(
            height: 60,
            child: const DrawerHeader(
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
    // Store guilds globally and refresh the global store here
    // await guild.refresh();
    setState(() {
      _refreshCount += 1;
    });
  }

}
