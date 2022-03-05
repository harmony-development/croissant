
import 'package:croissant/stream_controller.dart';
import 'package:flutter/material.dart';
import 'package:harmony_sdk/harmony_sdk.dart';
import 'package:fixnum/fixnum.dart';

class CState with ChangeNotifier {
  bool _isWideScreen = false;
  bool get isWideScreen => _isWideScreen;
  set isWideScreen(bool value) {
    _isWideScreen = value;
    notifyListeners();
  }

  late Client _client;
  Client get client => _client;

  late final StreamController _stream;

  Int64? _selectedGuildId;
  Int64? get selectedGuildId => _selectedGuildId;
  set selectedGuildId(Int64? value) {
    _selectedGuildId = value;
    _selectedChannelId = _lastSelectedChannel[value];
    notifyListeners();
  }

  Int64? _selectedChannelId;
  Int64? get selectedChannelId => _selectedChannelId;
  set selectedChannelId(Int64? value) {
    if (_selectedChannelId != null ) {
      if (_textController.text != "") {
        _textControllerCache[_selectedChannelId!] = _textController.text;
      }
      _textController.text = _textControllerCache[_selectedChannelId!] ?? "";
    }

    _selectedChannelId = value;
    _lastSelectedChannel[selectedGuildId] = value;
    notifyListeners();
  }

  final TextEditingController _textController = TextEditingController();
  final Map<Int64, String> _textControllerCache = {};
  TextEditingController get textController => _textController;

  late Int64 _ownUserId;
  Int64 get ownUserId => _ownUserId;
  Profile get ownProfile => _profiles[ownUserId]!;

  final Map<Int64, Profile> _profiles = {};
  Map<Int64, Profile> get profiles => _profiles;

  // todo: this entire thing might need to be keyed by host
  // because y'know, federation

  final Map<Int64,Guild> _guilds = {};
  Map<Int64,Guild> get guilds => _guilds;

  final Map<Int64, Map<Int64, Channel>> _channels = {};
  Map<Int64, Map<Int64, Channel>> get channels => _channels;

  Channel? get currentChannel => _channels[selectedGuildId]?[selectedChannelId];

  final Map<Int64?, Int64?> _lastSelectedChannel = {};
  Map<Int64?, Int64?> get lastSelectedChannel => _lastSelectedChannel;

  final Map<Int64, List<Int64>> _channelMessages = {};
  Map<Int64, List<Int64>> get channelMessages => _channelMessages;

  final Map<Int64, Message> _messages = {};
  Map<Int64, Message> get messages => _messages;

  Future<void> loadChannelMessages(int pageId) async {
    if (selectedChannelId == null) return;

    if (channelMessages[selectedChannelId] == null) {
      channelMessages[selectedChannelId!] = [];

      var res = await client.GetChannelMessages(GetChannelMessagesRequest(
        channelId: selectedChannelId,
        guildId: selectedGuildId
      ));

      for (var msg in res.messages) {
        _channelMessages[selectedChannelId]!.add(msg.messageId);
        messages[msg.messageId] = msg.message;
      }
    }

    notifyListeners();
  }

  Future<void> initialize(Client c, Int64 userId) async {
    _client = c;
    _ownUserId = userId;

    _stream = StreamController(state: this);

    var profile = await client.GetProfile(GetProfileRequest(userId: [userId]));
    _profiles[userId] = profile.profile.values.first;

    var guildList = await client.GetGuildList(GetGuildListRequest());
    var guild = await client.GetGuild(GetGuildRequest(guildIds: [...guildList.guilds.map((x) => x.guildId)]));
    for (var g in guildList.guilds) {
      var channels = await client.GetGuildChannels(GetGuildChannelsRequest(guildId: g.guildId));
      _channels[g.guildId] = {};
      for (var ch in channels.channels) {
        _channels[g.guildId]![ch.channelId] = ch.channel;
      }

      // todo: fetch all guild member profiles

      guilds[g.guildId] = guild.guild[g.guildId]!;
    }

    _stream.init();

    notifyListeners();
  }
}