import 'package:flutter/material.dart';
import 'package:harmony_sdk/harmony_sdk.dart';
import 'package:provider/provider.dart';
import 'package:winged_staccato/routes/utils.dart';

import 'state.dart';

class MemberItem extends StatefulWidget {
  final int index;

  MemberItem(this.index);

  @override
  _MemberItemState createState() => _MemberItemState();

}

class _MemberItemState extends State<MemberItem> {

  int _refreshCount;

  @override
  void initState() {
    super.initState();
    _refreshCount = 0;
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MainState>(context);
    User member = state.selectedGuild.members[widget.index];

    if (member.name == null || member.avatar == null) {
      loadMemberInfo(state);
      return ListTile(
        leading: CircleAvatar(backgroundColor: Colors.grey,),
        title: Text(member.id.toString()),
        onTap: () {},
      );
    }

    Widget avatarWidget;
    if (member.avatar.isEmpty)
      avatarWidget = CircleAvatar(backgroundColor: Colors.grey,);
    else {
      String avatarUrl = Utils.buildAvatarUrl(member.home, member.avatar);
      avatarWidget = CircleAvatar(
        backgroundColor: Colors.grey,
        backgroundImage: NetworkImage(avatarUrl),
      );
    }

    List<Widget> title = [];
    title.add(Text(member.name));
    if (member.isBot) {
      title.add(SizedBox(width: 5));
      title.add(Flexible(
        child: DecoratedBox(
          decoration: BoxDecoration(color: Colors.indigo[900],
              borderRadius: new BorderRadius.all(Radius.circular(10.0))),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            child: Text('BOT', style: TextStyle(fontSize: 10),),
          ),
        ),
      ));
    }

    return ListTile(
      leading: avatarWidget,
      title: Row(children: title,),
      onTap: () {},
    );
  }

  Future<void> loadMemberInfo(MainState state) async {
    await state.selectedGuild.members[widget.index].refresh();

    setState(() {
      _refreshCount += 1;
    });
  }

}