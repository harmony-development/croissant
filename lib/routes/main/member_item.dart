import 'package:flutter/material.dart';
import 'package:harmony_sdk/harmony_sdk.dart';
import 'package:provider/provider.dart';

import 'state.dart';

class MemberItem extends StatefulWidget {
  final int index;

  const MemberItem(this.index);

  @override
  _MemberItemState createState() => _MemberItemState();

}

class _MemberItemState extends State<MemberItem> {

  late int _memberId;

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MainState>(context);
    Profile? member = state.selectedGuildMembers[widget.index];
    int memberId = state.selectedGuildMembers.keys.toList()[widget.index];

    if (_memberId != memberId) {
      loadMemberInfo(state);
    }

    Widget avatarWidget;
    if (member?.userAvatar == null || member!.userAvatar.isEmpty) {
      avatarWidget = const CircleAvatar(backgroundColor: Colors.grey);
    }
    else {
      // String avatarUrl = Utils.buildAvatarUrl(member.home, member.userAvatar);
      String avatarUrl = member.userAvatar;
      avatarWidget = CircleAvatar(
        backgroundColor: Colors.grey,
        backgroundImage: NetworkImage(avatarUrl),
      );
    }

    String name = member?.userName == null ? memberId.toString() : member!.userName;
    List<Widget> title = [];
    title.add(Text(name));

    bool isBot = member?.isBot == null ? false : member!.isBot;
    if (isBot) {
      title.add(const SizedBox(width: 5));
      title.add(Flexible(
        child: DecoratedBox(
          decoration: BoxDecoration(color: Colors.indigo[900],
              borderRadius: const BorderRadius.all(Radius.circular(10.0))),
          child: const Padding(
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
    // Store guild members globally and refresh the store here
    // await state.selectedGuildMembers[widget.index].refresh();

    setState(() {
      _memberId = state.selectedGuildMembers.keys.toList()[widget.index];
    });
  }

}
