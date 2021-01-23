import 'package:flutter/foundation.dart';
import 'package:harmony_sdk/harmony_sdk.dart';

class MainState extends ChangeNotifier {
  List<Guild> _guilds;
  List<Guild> get guilds => _guilds;

  List<Channel> _channels;
  List<Channel> get channels => _channels;

  int _selectedChannelId;
  int get selectedChannelId => _selectedChannelId;
  Channel get selectedChannel => _channels?.firstWhere((channel) => channel.id == _selectedChannelId, orElse: () => null);

  int _selectedGuildId;
  int get selectedGuildId => _selectedGuildId;
  Guild get selectedGuild => _guilds?.firstWhere((guild) => guild.id == _selectedGuildId, orElse: () => null);

  List<User> _selectedGuildMembers;
  List<User> get selectedGuildMembers => _selectedGuildMembers;

  Future<void> updateGuilds(Homeserver home) => home.joinedGuilds().then((value) {
    _guilds = value;
    notifyListeners();
  });

  void selectGuild(int index) {
    _selectedGuildId = _guilds[index].id;
    _selectedChannelId = null;
    _channels = null;
    notifyListeners();
  }

  Future<void> updateChannels() => selectedGuild?.listChannels()?.then((value) {
    _channels = value;
    notifyListeners();
  });

  void selectChannel(int index) {
    _selectedChannelId = _channels[index].id;
    notifyListeners();
  }

  Future<void> updateMembers() => selectedGuild?.listMembers()?.then((value) {
    _selectedGuildMembers = value;
    notifyListeners();
  });

}