import 'package:croissant/routes/utils.dart';
import 'package:flutter/material.dart';
import 'package:harmony_sdk/harmony_sdk.dart';
import 'package:provider/provider.dart';
import 'package:croissant/routes/main/circle_button.dart';
import 'package:croissant/routes/main/guild_item.dart';
import 'package:croissant/routes/main/invite_dialog.dart';

import 'state.dart';

class GuildsDrawer extends StatelessWidget {
  GuildsDrawer(this.client);

  final Client client;

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MainState>(context);
    if (state.guilds.values.isEmpty) {
      state.updateGuilds(client);
      return const Drawer(
        child: Center(
          child: CircularProgressIndicator()
        )
      );
    }
    Guild? guild = state.selectedGuild;
    return Drawer(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 64, minWidth: 20),
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
                    child: Text(guild.name),
                  ),
                  decoration: const BoxDecoration(
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
            return GuildItem(index);
          }),
        Container(
          height: 64,
          padding: const EdgeInsets.all(8),
          child: CircleButton(
            child: const Icon(
              Icons.person_add
            ),
            onClick: () {
              showDialog(
                context: context,
                builder: (_) => InviteDialog(client),
              );
            },
          )
        ),
        Container(
            height: 64,
            padding: const EdgeInsets.all(8),
            child: CircleButton(
              child: const Icon(
                  Icons.exit_to_app
              ),
              onClick: () async {
                await PersistentStorage.clear();
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
      itemCount: state.channels == null ? 0 : state.channels?.length,
      itemBuilder: (BuildContext context, int index) {
        ChannelWithId? c = state.channels?[index];
        return Ink(
          color: c?.channelId == state.selectedChannelId ? Colors.pinkAccent : Colors.transparent,
          child: ListTile(
            title: Text(c?.channel.channelName ?? "none"),
            onTap: () {
              state.selectChannel(index);
            },
          )
        );
      }
    );
  }

}