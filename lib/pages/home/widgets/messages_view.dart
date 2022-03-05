import 'package:croissant/pages/home/widgets/message_item.dart';
import 'package:croissant/state.dart';
import 'package:croissant/utils/harmony_utils.dart';
import 'package:flutter/material.dart';
import 'package:harmony_sdk/harmony_sdk.dart';
import 'package:provider/provider.dart';

class MessagesView extends StatelessWidget {
  const MessagesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<CState>(context);
    if (state.selectedChannelId != null) {
      state.loadChannelMessages(0);
    }

    var messages = state.channelMessages[state.selectedChannelId];
    if (messages == null) return Column();

    messages.sort();

    return Expanded(child:
      Column(
        children: [
          Expanded(child:
            ListView(
              children: messages.reversed.map<Widget>((x) {
                MessageWithId message = MessageWithId(messageId: x, message: state.messages[x]!);

                if (messages.indexOf(x) > 0) {
                  Message prevMessage = state.messages[messages[messages.indexOf(x)-1]]!;

                  bool isExpired = (prevMessage.createdAt + 7 * 60 * 1000) < message.message.createdAt;

                  bool isSameAuthor = prevMessage.authorId == message.message.authorId;
                  bool isSameOverrideName = prevMessage.overrides.username == message.message.overrides.username;
                  bool isSameOverrideAvatar = prevMessage.overrides.avatar == message.message.overrides.avatar;

                  bool isTotallySamePerson = isSameAuthor && isSameOverrideName && isSameOverrideAvatar && !isExpired;

                  if (isTotallySamePerson) {
                    return InkWell(
                      child: Container(
                        margin: const EdgeInsets.only(left: 72),
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(message.message.content.text, style: const TextStyle(color: Colors.white70),),
                      ),
                      onTap: () {},
                    );
                  }
                }
                return MessageItem(message: message);
              }).toList(),
              reverse: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: buildMessageBox(context, state),
          ),
        ]
      )
    );
  }

  Widget buildMessageBox(BuildContext context, CState state) {
    return Row(
      children: [
        Expanded(child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(hintText: "Message #${state.currentChannel!.channelName}"),
            controller: state.textController,
            // todo: use a RawKeyboardListener - https://stackoverflow.com/a/64445417
            onSubmitted: (text) => trySendMessage(context, text),
          ))),
        IconButton(
          icon: const Icon(Icons.send, color: Colors.white, size: 30.0),
          onPressed: () => trySendMessage(context, state.textController.text),
        )
      ],
    );
  }

  Future<void> trySendMessage(BuildContext context, String text) async {
    var state = Provider.of<CState>(context, listen: false);

    try {
      await state.client.SendMessage(SendMessageRequest(
        guildId: state.selectedGuildId,
        channelId: state.selectedChannelId,
        content: SendMessageRequest_Content(text: state.textController.text)
      ));
      state.textController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:  Text("Send: $e")),);
    }
  }
}