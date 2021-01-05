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

  int _memberId;

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MainState>(context);
    User member = state.selectedGuildMembers[widget.index];

    if (_memberId != member.id)
      loadMemberInfo(state);

    Widget avatarWidget;
    if (member.avatar == null || member.avatar.isEmpty)
      avatarWidget = CircleAvatar(backgroundColor: Colors.grey,);
    else {
      String avatarUrl = Utils.buildAvatarUrl(member.home, member.avatar);
      avatarWidget = CircleAvatar(
        backgroundColor: Colors.grey,
        backgroundImage: NetworkImage(avatarUrl),
      );
    }

    String name = member.name == null ? member.id.toString() : member.name;
    List<Widget> title = [];
    title.add(Text(name));

    bool isBot = member.isBot == null ? false : member.isBot;
    if (isBot) {
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
    await state.selectedGuildMembers[widget.index].refresh();

    setState(() {
      _memberId = state.selectedGuildMembers[widget.index].id;
    });
  }

}