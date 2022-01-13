import 'package:flutter/material.dart';
import 'package:harmony_sdk/harmony_sdk.dart';
import 'package:provider/provider.dart';
import 'package:fixnum/fixnum.dart';

import '../utils.dart';
import 'circle_button.dart';
import 'state.dart';

class GuildItem extends StatefulWidget {
  final int index;

  const GuildItem(this.index);

  @override
  _GuildItemState createState() => _GuildItemState();
}

class _GuildItemState extends State<GuildItem> {

  int? _guildId;

  @override
  Widget build(BuildContext context) {

    MainState state = Provider.of<MainState>(context);
    Guild? guild = state.guilds.values.toList()[widget.index];
    int guildId = state.guilds.keys.toList()[widget.index];
    String? avatar = guild.picture;
    
    if (_guildId != guildId) {
      loadGuildInfo(state);
    }

    Widget avatarWidget;
    if (avatar == null || avatar.isEmpty) {
      avatarWidget = const CircleAvatar(
        backgroundColor: Colors.grey,
      );
    }
    else {
      String avatarUrl = avatar.startsWith(Utils.hmcScheme)
          ? Utils.fixHarmonyContentUrl(avatar)
          : avatar;
      avatarWidget = CircleAvatar(
        // backgroundColor: Colors.grey,
        backgroundImage: NetworkImage(avatarUrl),
      );
    }

    return Ink(
      height: 64,
      color: _isSelected(state) ? Colors.pinkAccent : Colors.transparent,
      child: CircleButton(
        child: avatarWidget,
        onClick: () {
          if (!_isSelected(state)) {
            state.selectGuild(widget.index);
            state.updateChannels();
          }
        },
      ));
  }

  bool _isSelected(MainState state) => Int64(state.guilds.keys.toList()[widget.index]) == state.selectedGuildId;

  Future<void> loadGuildInfo(MainState state) async {
    // TODO: Store guilds globally and refresh the store here
    // await state.guilds[widget.index].refresh();
    setState(() {
      _guildId = state.guilds.keys.toList()[widget.index];
    });
  }
}
