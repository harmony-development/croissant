
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
  set client(c) {
    _client = c;
    initialize();
  }

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
    _selectedChannelId = value;
    _lastSelectedChannel[selectedGuildId] = value;
    notifyListeners();
  }

  final Map<Int64,Guild> _guilds = {};
  Map<Int64,Guild> get guilds => _guilds;

  final Map<Int64, Map<Int64, Channel>> _channels = {};
  Map<Int64, Map<Int64, Channel>> get channels => _channels;

  final Map<Int64?, Int64?> _lastSelectedChannel = {};
  Map<Int64?, Int64?> get lastSelectedChannel => _lastSelectedChannel;

  Future<void> initialize() async {
    var guildList = await client.GetGuildList(GetGuildListRequest());
    var guild = await client.GetGuild(GetGuildRequest(guildIds: [...guildList.guilds.map((x) => x.guildId)]));
    for (var g in guildList.guilds) {
      var channels = await client.GetGuildChannels(GetGuildChannelsRequest(guildId: g.guildId));
      _channels[g.guildId] = {};
      for (var ch in channels.channels) {
        _channels[g.guildId]![ch.channelId] = ch.channel;
      }

      guilds[g.guildId] = guild.guild[g.guildId]!;
    }

    notifyListeners();
  }
}