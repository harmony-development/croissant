import 'dart:async';
import 'dart:developer';

import 'package:tuple/tuple.dart';
import 'package:flutter/material.dart';
import 'package:harmony_sdk/harmony_sdk.dart';
import 'package:winged_staccato/routes/main/message_item.dart';

class MessageList extends StatefulWidget {
  MessageList(this.channel);

  final Channel channel;

  @override
  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  final messageController = TextEditingController();

  Channel _channel;
  List<Message> _messages;
  StreamSubscription<GuildEvent> _sub;
  StreamController _controller;

  @override void dispose() {
    _sub.cancel();
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_messages == null || _channel?.id != widget.channel.id) {
      _channel = widget.channel;
      resetEventSubscription();
      queryMessageList(); // async query message list after build
      return CircularProgressIndicator();
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            reverse: true,
            itemCount: _messages == null ? 0 : _messages.length,
            itemBuilder: (BuildContext context, int index) {
              Message message = _messages[index];
              if (index + 1 < _messages.length) {
                Message prevMessage = _messages[index + 1];
                bool isSameAuthor = prevMessage.author.id == message.author.id;
                bool isSameOverrideName = prevMessage.override?.name == message.override?.name;
                bool isSameOverrideAvatar = prevMessage.override?.avatar == message.override?.avatar;
                bool isTotallySamePerson = isSameAuthor && isSameOverrideName && isSameOverrideAvatar;
                if (isTotallySamePerson) {
                  return InkWell(
                    child: Container(
                      margin: EdgeInsets.only(left: 72),
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Text(message.content, style: TextStyle(color: Colors.white70),),
                    ),
                    onTap: () {},
                  );
                }
              }
              return new MessageItem(message);
            })
        ),
        Row(
          children: [
            Expanded(child: Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Message',
                ),
                controller: messageController,
              ))),
            IconButton(
              icon: Icon(Icons.send, color: Colors.white, size: 30.0),
              onPressed: () async {
                try {
                  await _channel.sendMessage(messageController.text);
                  messageController.clear();
                } catch (e) {
                  Scaffold.of(context).showSnackBar(SnackBar(content:  Text("Send: $e")),);
                }
              },
            )
          ],
        )
      ],
    );
  }

  Future<void> resetEventSubscription() async {
    try {
      await _sub?.cancel();
      await _controller?.close();
      Tuple2 tuple = _channel.streamGuildEvents();
      _controller = tuple.item2;
      _sub = tuple.item1.listen((event) {
        log(event.toString());
        if (event is MessageSent) {
          if (event.message.channel == _channel.id) {
            setState(() {
              _messages = new List.from(_messages)
                ..insert(0, event.message);
            });
          }
        }
      }, onError: (e) => log(e.toString()), onDone: () => log('Done'));
      log('Test!');
    } catch(e) {
      log(e.toString());
    }
  }

  Future<void> queryMessageList() {
    return widget.channel.getMessages(null).then((value) => setState(() {
      _messages = value;
    }));
  }

}
