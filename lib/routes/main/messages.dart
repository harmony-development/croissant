import 'dart:async';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:harmony_sdk/harmony_sdk.dart' as sdk;
import 'package:harmony_sdk/harmony_sdk.dart';
import 'package:croissant/routes/main/message_item.dart';
import 'package:provider/provider.dart';
import 'state.dart';
import 'package:fixnum/fixnum.dart';

class MessageList extends StatefulWidget {
  const MessageList(this.client, this.channel);

  final Client client;
  final ChannelWithId channel;

  @override
  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  final messageController = TextEditingController();

  List<MessageWithId> _messages = [];
  Channel? _channel;
  StreamSubscription<StreamEventsResponse>? _sub;
  StreamController? _controller;

  @override void dispose() {
    _sub?.cancel();
    _controller?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MainState state = Provider.of<MainState>(context);

    if (_sub == null) {
      resetEventSubscription();
      queryMessageList(state.selectedGuildId!); // async query message list after build
      return Column(children: const [
        Expanded(child: Center(
          child: CircularProgressIndicator()
        ))
      ]);
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            reverse: true,
            itemCount: _messages == null ? 0 : _messages.length,
            itemBuilder: (BuildContext context, int index) {
              MessageWithId message = _messages[index];
              if (index + 1 < _messages.length) {
                MessageWithId prevMessage = _messages[index + 1];
                bool isSameAuthor = prevMessage.message.authorId == message.message.authorId;
                bool isSameOverrideName = prevMessage.message.overrides.username == message.message.overrides.username;
                bool isSameOverrideAvatar = prevMessage.message.overrides.avatar == message.message.overrides.avatar;
                bool isTotallySamePerson = isSameAuthor && isSameOverrideName && isSameOverrideAvatar;
                if (isTotallySamePerson) {
                  return InkWell(
                    child: Container(
                      margin: const EdgeInsets.only(left: 72),
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(message.message.content.textMessage.content.text, style: const TextStyle(color: Colors.white70),),
                    ),
                    onTap: () {},
                  );
                }
              }
              return MessageItem(widget.client, message);
            })
        ),
        Row(
          children: [
            Expanded(child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Message',
                ),
                controller: messageController,
              ))),
            IconButton(
              icon: const Icon(Icons.send, color: Colors.white, size: 30.0),
              onPressed: () async {
                try {
                  await widget.client.SendMessage(SendMessageRequest(
                    guildId: Int64(state.selectedGuildId!),
                    channelId: widget.channel.channelId,
                    content: Content(textMessage: Content_TextContent(content: FormattedText(text: messageController.text)))));
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
      var stream = widget.client.StreamEvents(StreamEventsRequest(
        // subscribeToGuild: state.currentGuildId,
      ));
      setState(() {
        _sub = stream.listen((event) {
          print(event.toString());
          switch (event.whichEvent()) {
            case sdk.StreamEventsResponse_Event.chat:
              switch (event.chat.whichEvent()) {
                case sdk.StreamEvent_Event.sentMessage:
                  if (event.chat.sentMessage.channelId == widget.channel.channelId) {
                    setState(() {
                      _messages = List.from(_messages)
                        ..insert(0, MessageWithId(message: event.chat.sentMessage.message, messageId: event.chat.sentMessage.messageId));
                    });
                  }
                  break;
                case sdk.StreamEvent_Event.deletedMessage:
                  if (event.chat.deletedMessage.channelId == widget.channel.channelId) {
                    setState(() {
                      _messages.removeWhere((message) => event.chat.deletedMessage.messageId == message.messageId);
                    });
                  }
                  break;
                default:
              }
              break;
            default:
          }
        }, onError: (e) => print(e), onDone: () => print('Done'));
      });
    } catch(e) {
      print(e);
    }
  }

  Future<void> queryMessageList(int guildId) async {
    var value = await widget.client.GetChannelMessages(GetChannelMessagesRequest(
      guildId: Int64(guildId),
      channelId: widget.channel.channelId
    ));
    setState(() {
      _messages = value.messages;
    });
  }

}
