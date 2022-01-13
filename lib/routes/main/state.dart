import 'package:flutter/foundation.dart';
import 'package:harmony_sdk/harmony_sdk.dart';
import 'package:fixnum/fixnum.dart';

class MainState extends ChangeNotifier {
  Map<int,Guild> _guilds = {};
  Map<int,Guild> get guilds => _guilds;

  List<ChannelWithId>? _channels;
  List<ChannelWithId>? get channels => _channels;

  int? _selectedChannelId;
  int? get selectedChannelId => _selectedChannelId;
  ChannelWithId? get selectedChannel {
    var chs = _channels?.where((channel) => channel.channelId == _selectedChannelId);
    if (chs?.isEmpty ?? true) return null;
    return chs?.first;
  }

  int? _selectedGuildId;
  int? get selectedGuildId => _selectedGuildId;
  Guild? get selectedGuild => _guilds.containsKey(_selectedGuildId?.toInt()) ? _guilds[_selectedGuildId?.toInt()] : null;

  Map<int,Profile> _selectedGuildMembers = {};
  Map<int,Profile> get selectedGuildMembers => _selectedGuildMembers;

  Client? _client;

  bool isUpdating = false;

  Future<void> updateGuilds(Client client) async {
    if (isUpdating) return;
    isUpdating = true;

    var guildList = await client.GetGuildList(GetGuildListRequest());
    Map<int,Guild> guilds = {};
    for (var g in guildList.guilds) {
      var guild = await client.GetGuild(GetGuildRequest(guildId: g.guildId));
      guilds[g.guildId.toInt()] = guild.guild;
    }

    _guilds = guilds;
    _client = client;
    notifyListeners();

    isUpdating = false;
  }

  void selectGuild(int index) {
    _selectedGuildId = _guilds.keys.toList()[index];
    _selectedChannelId = null;
    _channels = null;
    notifyListeners();
  }

  Future<void> updateChannels() => _client!.GetGuildChannels(GetGuildChannelsRequest(guildId: Int64(_selectedGuildId!))).then((value) {
    _channels = value.channels;
    notifyListeners();
  });

  void selectChannel(int index) {
    _selectedChannelId = _channels![index].channelId.toInt();
    notifyListeners();
  }

  Future<void> updateMembers() => _client!.GetGuildMembers(GetGuildMembersRequest(guildId: Int64(_selectedGuildId!))).then((value) {
    Map<int,Profile> members = {};
    value.members.forEach((member) => {
      _client!.GetProfile(GetProfileRequest(userId: member)).then((GetProfileResponse profileResponse) => {
        members[member.toInt()] = profileResponse.profile
      })
    });
    _selectedGuildMembers = members;
    notifyListeners();
  });

}
