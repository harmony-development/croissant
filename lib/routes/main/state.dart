import 'package:flutter/foundation.dart';
import 'package:harmony_sdk/harmony_sdk.dart';

class MainState extends ChangeNotifier {
  List<Guild> _guilds;
  List<Guild> get guilds => _guilds;

  List<Channel> _channels;
  List<Channel> get channels => _channels;

  Channel _selectedChannel;
  Channel get selectedChannel => _selectedChannel;

  Guild get selectedGuild => _guilds.firstWhere((guild) => guild.id == _selectedChannel.guild);
  int get selectedGuildIndex => _guilds.indexWhere((guild) => guild.id == _selectedChannel.guild);

  List<User> _selectedGuildMembers;
  List<User> get selectedGuildMembers => _selectedGuildMembers;

  Future<void> updateGuilds(Homeserver home) => home.joinedGuilds().then((value) {
    _guilds = value;
    notifyListeners();
  });

  Future<void> updateChannels(int index) => _guilds[index].listChannels().then((value) {
    _channels = value;
    _selectedChannel = value[0];
    notifyListeners();
  });

  Future<void> updateMembers(int index) => _guilds[index].listMembers().then((value) {
    _selectedGuildMembers = value;
    notifyListeners();
  });

  void setSelectedChannel(int index) {
    _selectedChannel = _channels[index];
    notifyListeners();
  }

}