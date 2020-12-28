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

  String _authorName;
  String _authorAvatarUrl;

  @override
  void initState() {
    super.initState();
    _authorName = widget.message.author.id.toString();
    _authorAvatarUrl = '';
    loadAuthorInfo();
  }

  @override
  Widget build(BuildContext context) {
    Widget avatar;
    if (_authorAvatarUrl.isEmpty)
      avatar = CircleAvatar(backgroundColor: Colors.grey,);
    else
      avatar = CircleAvatar(
        backgroundColor: Colors.grey,
        backgroundImage: NetworkImage(_authorAvatarUrl),
      );

    return ListTile(
      leading: avatar,
      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
      title: Row(
        children: [
          Flexible(
            child: Text(_authorName),
          ),
          SizedBox(width: 10),
          Container(
            width: 150,
            child: Text(Utils.formatDateTime(widget.message.createdAt),
              style: TextStyle(color: Colors.grey),)
          ),
        ],
      ),
      subtitle: Text(widget.message.content),
      onTap: () {},
    );
  }

  Future<void> loadAuthorInfo() async {
    await widget.message.author.refresh();
    var memberName = await widget.message.author.name;
    var avatarId = await widget.message.author.avatar;

    var avatarUrl = '';
    if (avatarId.isNotEmpty)
      avatarUrl = Utils.buildAvatarUrl(widget.message.author.homeserver, avatarId);

    setState(() {
      _authorName = memberName;
      _authorAvatarUrl = avatarUrl;
    });
    return;
  }



}