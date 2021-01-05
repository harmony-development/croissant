import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:harmony_sdk/harmony_sdk.dart';

import '../utils.dart';

class MessageItem extends StatefulWidget {

  final Message message;

  MessageItem(this.message);

  @override
  _MessageItemState createState() => _MessageItemState();

}

class _MessageItemState extends State<MessageItem> {

  int _msgId;
  String _authorName;
  String _authorAvatarUrl;
  bool _isAuthorBot;

  @override
  void initState() {
    super.initState();
    _msgId = widget.message.id;
    _authorName = widget.message.author.id.toString();
    _authorAvatarUrl = '';
    _isAuthorBot = false;
    loadAuthorInfo();
  }

  @override
  Widget build(BuildContext context) {
    if (_msgId != widget.message.id) {
      loadAuthorInfo();
    }

    Widget avatar;
    if (_authorAvatarUrl.isEmpty)
      avatar = CircleAvatar(backgroundColor: Colors.grey,);
    else
      avatar = CircleAvatar(
        backgroundColor: Colors.grey,
        backgroundImage: NetworkImage(_authorAvatarUrl),
      );

    List<Widget> title = [];
    title.add(Flexible(
      child: Text(_authorName, style: TextStyle(fontSize: 14),),
    ));
    title.add(SizedBox(width: 5));

    if (_isAuthorBot) {
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
      title.add(SizedBox(width: 5));
    }

    title.add(SizedBox(
      width: 106,
      child: Container(
        child: Text(Utils.formatDateTime(widget.message.createdAt),
        style: TextStyle(color: Colors.grey, fontSize: 12),)
      ),));

    return ListTile(
      leading: avatar,
      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
      title: Row(
        children: title,
      ),
      subtitle: Text(widget.message.content),
      onTap: () {},
    );
  }

  Future<void> loadAuthorInfo() async {
    User author = widget.message.author;
    String memberName;
    String avatar;
    bool isBot;
    if (author.name == null || author.avatar == null || author.isBot == null) {
      await widget.message.author.refresh();
    }

    memberName = author.name;
    avatar = author.avatar;
    isBot = author.isBot;

    Override override = widget.message.override;
    if (override != null && override.name.isNotEmpty) {
      memberName = override.name;
      avatar = override.avatar;
    }

    String avatarUrl = avatar.isEmpty ? '' : avatar.contains('http') ? avatar :
    Utils.buildAvatarUrl(author.home, avatar);

    setState(() {
      _msgId = widget.message.id;
      _authorName = memberName;
      _authorAvatarUrl = avatarUrl;
      _isAuthorBot = isBot;
    });
    return;
  }

}