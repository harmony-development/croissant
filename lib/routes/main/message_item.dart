import 'package:flutter/material.dart';
import 'package:harmony_sdk/harmony_sdk.dart';
import 'package:fixnum/fixnum.dart';

import '../utils.dart';


class MessageItem extends StatefulWidget {

  final Client client;
  final MessageWithId message;

  const MessageItem(this.client, this.message);

  @override
  _MessageItemState createState() => _MessageItemState();

}

class _MessageItemState extends State<MessageItem> {

  late Int64 _msgId;
  late String _authorName;
  late String _authorAvatarUrl;
  late bool _isAuthorBot;

  @override
  void initState() {
    super.initState();
    _msgId = widget.message.messageId;
    _authorName = widget.message.message.authorId.toString();
    _authorAvatarUrl = '';
    _isAuthorBot = false;
    loadAuthorInfo();
  }

  @override
  Widget build(BuildContext context) {
    if (_msgId != widget.message.messageId) {
      loadAuthorInfo();
    }

    Widget avatar;
    if (_authorAvatarUrl.isEmpty) {
      avatar = const CircleAvatar(backgroundColor: Colors.grey);
    } else {
      avatar = CircleAvatar(
        backgroundColor: Colors.grey,
        backgroundImage: NetworkImage(_authorAvatarUrl),
      );
    }

    List<Widget> title = [];
    title.add(Flexible(
      child: Text(_authorName, style: const TextStyle(fontSize: 14),),
    ));
    title.add(const SizedBox(width: 5));

    if (_isAuthorBot) {
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
      title.add(SizedBox(width: 5));
    }

    title.add(SizedBox(
      width: 106,
      child: Container(
        child: Text(Utils.formatDateTime(widget.message.message.createdAt.toInt()),
        style: const TextStyle(color: Colors.grey, fontSize: 12),)
      ),));

    return ListTile(
      leading: avatar,
      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
      title: Row(
        children: title,
      ),
      subtitle: Text(widget.message.message.content.textMessage.content.text),
      onTap: () {},
    );
  }

  Future<void> loadAuthorInfo() async {
    Profile? author;
    GetProfileResponse resp = await widget.client.GetProfile(GetProfileRequest(userId: widget.message.message.authorId));
    author = resp.profile;

    String memberName;
    String avatar;
    bool isBot;
    if (author == null || author!.userName == null || author!.userAvatar == null || author!.isBot == null) {
      // TODO: store profiles globally and refresh the store here
      // await widget.message.message.author.refresh();
      return;
    }

    memberName = author!.userName;
    avatar = author!.userAvatar;

    // todo: don't show bot tag on bridged posts
    isBot = author!.isBot;

    Overrides overrides = widget.message.message.overrides;
    if (overrides != null && overrides.username.isNotEmpty) {
      memberName = overrides.username;
      avatar = overrides.avatar;
    }

     String avatarUrl = avatar.isEmpty ? '' : avatar.contains('http') ? avatar :
     Utils.buildAvatarUrl(widget.client.server, avatar);

    setState(() {
      _msgId = widget.message.messageId;
      _authorName = memberName;
      _authorAvatarUrl = avatarUrl;
      _isAuthorBot = isBot;
    });
    return;
  }

}
