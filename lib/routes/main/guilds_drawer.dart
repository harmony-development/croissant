import 'package:flutter/material.dart';
import 'package:harmony_sdk/harmony_sdk.dart';
import 'package:hive/hive.dart';
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
    Guild guild = state.selectedGuild;
    return Drawer(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 64, minWidth: 20),
            child: buildGuildList(state, context),
          ),
          Expanded(
            child: guild == null ? Container() :
            Column(
              children: [
                Container(
                  height: 100,
                  margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  child: Center(
                    child: guild == null ? Container() :
                    Text(guild.name == null ? "null" : guild.name),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                ),
                state.channels == null ? Container() : buildChannelList(state, context)
              ],
            )
          ),
        ])
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
        ),
        Container(
            height: 64,
            padding: EdgeInsets.all(8),
            child: CircleButton(
              child: Icon(
                  Icons.exit_to_app
              ),
              onClick: () async {
                await Hive.box('box').clear();
                Navigator.pushNamedAndRemoveUntil(context, '/onboard', (r) => false);
              },
            )
        )
      ],
    );
  }

  Widget buildChannelList(MainState state, BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: state.channels == null ? 0 : state.channels.length,
      itemBuilder: (BuildContext context, int index) {
        Channel c = state.channels[index];
        return Ink(
          color: c.id == state.selectedChannelId ? Colors.pinkAccent : Colors.transparent,
          child: ListTile(
            title: Text(c.name),
            onTap: () {
              state.selectChannel(index);
            },
          )
        );
      }
    );
  }

}