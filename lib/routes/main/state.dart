import 'package:flutter/foundation.dart';
import 'package:harmony_sdk/harmony_sdk.dart';

class MainState extends ChangeNotifier {
  List<Guild> _guilds;
  List<Guild> get guilds => _guilds;

  List<Channel> _channels;
  List<Channel> get channels => _channels;

  Channel _selectedChannel;
  Channel get selectedChannel => _selectedChannel;

  Future<void> updateGuilds(Homeserver home) => home.joinedGuilds().then((value) {
    _guilds = value;
    notifyListeners();
  });
  Future<void> updateChannels(int index) => _guilds[index].listChannels().then((value) {
    _channels = value;
    _selectedChannel = value[0];
    notifyListeners();
  });

  void setSelectedChannel(int index) {
    _selectedChannel = _channels[index];
    notifyListeners();
  }
}