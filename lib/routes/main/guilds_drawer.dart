import 'package:flutter/material.dart';
import 'package:harmony_sdk/harmony_sdk.dart';
import 'package:provider/provider.dart';
import 'package:winged_staccato/routes/main/circle_button.dart';
import 'package:winged_staccato/routes/main/guild_item.dart';
import 'package:winged_staccato/routes/main/invite_dialog.dart';

import 'state.dart';

class GuildsDrawer extends StatelessWidget {
  GuildsDrawer(this.home);

  final Homeserver home;

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MainState>(context);
    if (state.guilds == null) {
      state.updateGuilds(home);
      return Drawer(
        child: Center(
          child: CircularProgressIndicator()
        )
      );
    }
    return Drawer(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 64, minWidth: 20),
            child: buildGuildList(state, context),
          ),
          Expanded(
            child: state.channels == null ? Container() : buildChannelList(state, context),
          ),
        ],
      ),
    );
  }

  Widget buildGuildList(MainState state, BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          reverse: true,
          itemCount: state.guilds == null ? 0 : state.guilds.length,
          itemBuilder: (BuildContext context, int index) {
            Guild g = state.guilds[index];
            return GuildItem(index);
          }),
        Container(
          height: 64,
          padding: EdgeInsets.all(8),
          child: CircleButton(
            child: Icon(
              Icons.person_add
            ),
            onClick: () {
              showDialog(
                context: context,
                builder: (_) => InviteDialog(home),
              );
            },
          )
        )
      ],
    );
  }

  Widget buildChannelList(MainState state, BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Column(
      children: [
        Container(
          height: 100,
          margin: EdgeInsets.only(top: statusBarHeight),
          child: Center(
            child: state.selectedChannel == null ? Container() : Text(state.selectedGuild.name),
          ),
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: state.channels == null ? 0 : state.channels.length,
          itemBuilder: (BuildContext context, int index) {
            Channel c = state.channels[index];
            return Ink(
              color: c.id == state.selectedChannel?.id ? Colors.pinkAccent : Colors.transparent,
              child: ListTile(
                title: Text(c.name),
                onTap: () {
                  Provider.of<MainState>(context, listen: false).setSelectedChannel(index);
                },
              )
            );
          }
        )
      ]
    );
  }

}