// ignore_for_file: implementation_imports, invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:croissant/state.dart';
import 'package:harmony_sdk/harmony_sdk.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:harmony_sdk/src/protocol/chat/v1/stream.pb.dart' as chat;
import 'package:harmony_sdk/src/protocol/emote/v1/stream.pb.dart' as emote;
import 'package:harmony_sdk/src/protocol/profile/v1/stream.pb.dart' as profile;

class StreamController {
  StreamController({required this.state});

  final CState state;

  WebSocketChannel? socket;

  void init() {
    if (socket != null && socket!.closeCode == null) return;

    socket = WebSocketChannel.connect(
      state.client.wsServer.replace(path: "/protocol.chat.v1.ChatService/StreamEvents"),
      protocols: ["hrpc1", state.client.token!.sessionToken]
    );

    socket!.sink.done.then((value) {
      print("websocket closed!");
    });

    socket!.stream.listen((event) {
      try {
        receivedMessage(event);
      } catch (e, stack) {
        print("Error in WebSocket handler: $e");
        print(stack);
      }
    });
  }

  Future<void> receivedMessage(List<int> data) async {
    var event = StreamEventsResponse.fromBuffer(data.sublist(1));

    switch (event.whichEvent()) {
      case StreamEventsResponse_Event.chat:
        await receivedChatEvent(event.chat);
        break;
      case StreamEventsResponse_Event.emote:
        receivedEmoteEvent(event.emote);
        break;
      case StreamEventsResponse_Event.profile:
        await receivedProfileEvent(event.profile);
        break;
      case StreamEventsResponse_Event.notSet:
        // this should never happen
        break;
    }
  }

  Future<void> receivedChatEvent(chat.StreamEvent event) async {
    switch (event.whichEvent()) {
      case StreamEvent_Event.guildAddedToList:
        var guild = await state.client.GetGuild(GetGuildRequest(guildIds: [event.guildAddedToList.guildId]));
        state.guilds.addAll({ event.guildAddedToList.guildId: guild.guild.values.first });
        state.notifyListeners();
        break;
      case StreamEvent_Event.guildRemovedFromList:
        state.guilds.remove(event.guildRemovedFromList.guildId);
        if (state.selectedGuildId == event.guildRemovedFromList.guildId) {
          state.selectedGuildId = null;
        }
        break;
      case StreamEvent_Event.actionPerformed:
        // we are not a bot :)
        break;
      case StreamEvent_Event.sentMessage:
        state.messages.addAll({ event.sentMessage.messageId: event.sentMessage.message });
        if (state.channelMessages[event.sentMessage.channelId] == null) state.channelMessages[event.sentMessage.channelId] = [];
        state.channelMessages[event.sentMessage.channelId]!.add(event.sentMessage.messageId);
        state.notifyListeners();
        break;
      case StreamEvent_Event.editedMessage:
        // trollcrazy
        var message = await state.client.GetMessage(GetMessageRequest(
          channelId: event.editedMessage.channelId,
          guildId: event.editedMessage.guildId,
          messageId: event.editedMessage.messageId
        ));
        state.messages.addAll({ event.editedMessage.messageId: message.message });
        state.notifyListeners();
        break;
      case StreamEvent_Event.deletedMessage:
        state.messages.remove(event.deletedMessage.messageId);
        state.channelMessages[event.deletedMessage.channelId]?.remove(event.deletedMessage.messageId);
        state.notifyListeners();
        break;
      case StreamEvent_Event.createdChannel:
        // TODO: Handle this case.
        break;
      case StreamEvent_Event.editedChannel:
        // TODO: Handle this case.
        break;
      case StreamEvent_Event.deletedChannel:
        // TODO: Handle this case.
        break;
      case StreamEvent_Event.editedGuild:
        // TODO: Handle this case.
        break;
      case StreamEvent_Event.deletedGuild:
        // TODO: Handle this case.
        break;
      case StreamEvent_Event.joinedMember:
        // TODO: Handle this case.
        break;
      case StreamEvent_Event.leftMember:
        // TODO: Handle this case.
        break;
      case StreamEvent_Event.typing:
        // TODO: Handle this case.
        break;
      case StreamEvent_Event.roleCreated:
        // TODO: Handle this case.
        break;
      case StreamEvent_Event.roleDeleted:
        // TODO: Handle this case.
        break;
      case StreamEvent_Event.roleMoved:
        // TODO: Handle this case.
        break;
      case StreamEvent_Event.roleUpdated:
        // TODO: Handle this case.
        break;
      case StreamEvent_Event.rolePermsUpdated:
        // TODO: Handle this case.
        break;
      case StreamEvent_Event.userRolesUpdated:
        // TODO: Handle this case.
        break;
      case StreamEvent_Event.permissionUpdated:
        // TODO: Handle this case.
        break;
      case StreamEvent_Event.channelsReordered:
        // TODO: Handle this case.
        break;
      case StreamEvent_Event.editedChannelPosition:
        // TODO: Handle this case.
        break;
      case StreamEvent_Event.messagePinned:
        // TODO: Handle this case.
        break;
      case StreamEvent_Event.messageUnpinned:
        // TODO: Handle this case.
        break;
      // case StreamEvent_Event.reactionUpdated:
        // TODO: Handle this case.
        // break;
      case StreamEvent_Event.ownerAdded:
        // TODO: Handle this case.
        break;
      case StreamEvent_Event.ownerRemoved:
        // TODO: Handle this case.
        break;
      case StreamEvent_Event.inviteReceived:
        // TODO: Handle this case.
        break;
      case StreamEvent_Event.inviteRejected:
        // TODO: Handle this case.
        break;
      case StreamEvent_Event.inviteCreated:
        // TODO: Handle this case.
        break;
      case StreamEvent_Event.inviteDeleted:
        // TODO: Handle this case.
        break;
      case StreamEvent_Event.inviteUsed:
        // TODO: Handle this case.
        break;
      case StreamEvent_Event.notSet:
        // this should never happen
        break;
      case StreamEvent_Event.newReactionAdded:
        // TODO: Handle this case.
        break;
      case StreamEvent_Event.reactionAdded:
        // TODO: Handle this case.
        break;
      case StreamEvent_Event.reactionRemoved:
        // TODO: Handle this case.
        break;
      case StreamEvent_Event.privateChannelDeleted:
        // TODO: Handle this case.
        break;
      case StreamEvent_Event.privateChannelAddedToList:
        // TODO: Handle this case.
        break;
      case StreamEvent_Event.privateChannelRemovedFromList:
        // TODO: Handle this case.
        break;
      case StreamEvent_Event.userJoinedPrivateChannel:
        // TODO: Handle this case.
        break;
      case StreamEvent_Event.userLeftPrivateChannel:
        // TODO: Handle this case.
        break;
      }
    }

  Future<void> receivedEmoteEvent(emote.StreamEvent event) async {
    switch (event.whichEvent()) {
      case emote.StreamEvent_Event.emotePackAdded:
        // TODO: Handle this case.
        break;
      case emote.StreamEvent_Event.emotePackUpdated:
        // TODO: Handle this case.
        break;
      case emote.StreamEvent_Event.emotePackDeleted:
        // TODO: Handle this case.
        break;
      case emote.StreamEvent_Event.emotePackEmotesUpdated:
        // TODO: Handle this case.
        break;
      case emote.StreamEvent_Event.notSet:
        // this should never happen
        break;
    }
  }

  Future<void> receivedProfileEvent(profile.StreamEvent event) async {
    switch (event.whichEvent()) {
      case profile.StreamEvent_Event.profileUpdated:
        var profile = await state.client.GetProfile(GetProfileRequest(userId: [event.profileUpdated.userId]));
        state.profiles[profile.profile.keys.first] = profile.profile.values.first;
        state.notifyListeners();
        break;
      case profile.StreamEvent_Event.statusUpdated:
        // TODO: Handle this case.
        break;
      case profile.StreamEvent_Event.notSet:
        // this should never happen
        break;
    }
  }
}
