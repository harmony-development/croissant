import 'package:croissant/state.dart';
import 'package:croissant/utils/harmony_utils.dart';
import 'package:flutter/material.dart';
import 'package:harmony_sdk/harmony_sdk.dart';
import 'package:provider/provider.dart';

class MessageItem extends StatefulWidget {
  const MessageItem({Key? key, required this.message}): super(key: key);

  final MessageWithId message;

  @override
  _MessageItemState createState() => _MessageItemState();

}

class _MessageItemState extends State<MessageItem> {

  late String _authorName;
  late String _authorAvatarUrl;
  late bool _isAuthorBot;

  @override
  void initState() {
    super.initState();
    _authorName = widget.message.message.authorId.toString();
    _authorAvatarUrl = '';
    _isAuthorBot = false;
  }

  @override
  Widget build(BuildContext context) {
    loadAuthorInfo(context);

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
    title.add(Flexible(child: Text(_authorName, style: const TextStyle(fontSize: 14))));
    title.add(const SizedBox(width: 5));

    if (_isAuthorBot) {
      title.add(Flexible(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.indigo[900],
            borderRadius: const BorderRadius.all(Radius.circular(10.0))
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            child: Text('BOT', style: TextStyle(fontSize: 10)),
          ),
        ),
      ));
      title.add(const SizedBox(width: 5));
    }

    title.add(SizedBox(
      width: 106,
      child: Text(
        Utils.formatDateTime(widget.message.message.createdAt.toInt()),
        style: const TextStyle(color: Colors.grey, fontSize: 12)),
      )
    );

    return ListTile(
      leading: avatar,
      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
      title: Row(
        children: title,
      ),
      subtitle: Text(widget.message.message.content.text),
      onTap: () {},
    );
  }

  Future<void> loadAuthorInfo(BuildContext context) async {
    var state = Provider.of<CState>(context, listen: false);

    Profile? author;

    var a = state.profiles[widget.message.message.authorId];
    if (a != null) author = a;

    String memberName;
    String avatar;
    bool isBot;

    if (author == null) {
      GetProfileResponse resp = await state.client.GetProfile(GetProfileRequest(userId: [widget.message.message.authorId]));
      author = resp.profile[widget.message.message.authorId]!;
    }

    memberName = author.userName;
    avatar = author.userAvatar;

    // todo: don't show bot tag on bridged posts
    isBot = author.accountKind == AccountKind.ACCOUNT_KIND_BOT;

    Overrides overrides = widget.message.message.overrides;
    if (widget.message.message.hasOverrides()) {
      if (overrides.username.isNotEmpty) memberName = overrides.username;
      if (overrides.avatar.isNotEmpty) avatar = overrides.avatar;
    }

    String avatarUrl = avatar.isEmpty ? '' : avatar.contains('http') ? avatar :
    Utils.buildAvatarUrl(state.client.server, avatar);

    setState(() {
      _authorName = memberName;
      _authorAvatarUrl = avatarUrl;
      _isAuthorBot = isBot;
    });
    return;
  }

}
