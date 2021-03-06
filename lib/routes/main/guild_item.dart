import 'package:flutter/material.dart';
import 'package:harmony_sdk/harmony_sdk.dart';
import 'package:provider/provider.dart';

import '../utils.dart';
import 'circle_button.dart';
import 'state.dart';

class GuildItem extends StatefulWidget {
  final int index;

  GuildItem(this.index);

  @override
  _GuildItemState createState() => _GuildItemState();
}

class _GuildItemState extends State<GuildItem> {

  int _guildId;

  @override
  Widget build(BuildContext context) {
    MainState state = Provider.of<MainState>(context);
    Guild guild = state.guilds[widget.index];
    String avatar = guild.avatar;

    if (_guildId != guild.id)
      loadGuildInfo(state);

    Widget avatarWidget;
    if (avatar == null || avatar.isEmpty)
      avatarWidget = CircleAvatar(
        backgroundColor: Colors.grey,
      );
    else {
      String avatarUrl = avatar.startsWith(Utils.hmcScheme)
          ? Utils.fixHarmonyContentUrl(avatar)
          : avatar;
      avatarWidget = CircleAvatar(
        backgroundColor: Colors.grey,
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

  bool _isSelected(MainState state) => state.guilds[widget.index].id == state.selectedGuildId;

  Future<void> loadGuildInfo(MainState state) async {
    await state.guilds[widget.index].refresh();
    setState(() {
      _guildId = state.guilds[widget.index].id;
    });
  }
}
