import 'dart:async';

import 'package:flutter/material.dart';
import 'package:harmony_sdk/harmony.dart';

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
  StreamSubscription<GuildEvent> _cancelingSub;

  @override void dispose() {
    _sub.cancel();
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
                shrinkWrap: true,
                reverse: true,
                itemCount: _messages == null ? 0 : _messages.length,
                itemBuilder: (BuildContext context, int index) {
                  Message m = _messages[index];
                  return ListTile(
                    title: Text(m.content),
                    onTap: () {},
                  );
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

  void resetEventSubscription() {
    if(_sub != null) {
      _cancelingSub = _sub;
      _cancelingSub.cancel().then((_) => _cancelingSub = null);
    }
    _sub = _channel.streamGuildEvents().listen((event) {
      if (event is MessageSent) {
        if (event.message.channelId == _channel.id) {
          setState(() {
            _messages = new List.from(_messages)
              ..insert(0, event.message);
          });
        }
      }
    });
  }

  Future<void> queryMessageList() {
    return widget.channel.getMessages(null).then((value) => setState(() {
      _messages = value;
    }));
  }

}
