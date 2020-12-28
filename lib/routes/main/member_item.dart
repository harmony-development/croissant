import 'package:flutter/material.dart';
import 'package:harmony_sdk/harmony_sdk.dart';
import 'package:winged_staccato/routes/utils.dart';

class MemberItem extends StatefulWidget {

  final User member;

  MemberItem(this.member);

  @override
  _MemberItemState createState() => _MemberItemState();

}

class _MemberItemState extends State<MemberItem> {

  String _name;
  String _avatarUrl;

  @override
  void initState() {
    super.initState();
    _name = widget.member.id.toString();
    _avatarUrl = '';
    loadMemberInfo();
  }

  @override
  Widget build(BuildContext context) {
    Widget avatar;
    if (_avatarUrl.isEmpty)
      avatar = CircleAvatar(backgroundColor: Colors.grey,);
    else
      avatar = CircleAvatar(
        backgroundColor: Colors.grey,
        backgroundImage: NetworkImage(_avatarUrl),
      );
    return ListTile(
      leading: avatar,
      title: Text(_name),
      onTap: () {},
    );
  }

  Future<void> loadMemberInfo() async {
    var memberName = await widget.member.name;
    var avatarId = await widget.member.avatar;

    var avatarUrl = '';
    if (avatarId.isNotEmpty)
      avatarUrl = Utils.buildAvatarUrl(widget.member.homeserver, avatarId);

    setState(() {
      _name = memberName;
      _avatarUrl = avatarUrl;
    });
    return;
  }

}