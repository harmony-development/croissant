import 'package:flutter/material.dart';
import 'package:harmony_sdk/harmony_sdk.dart';
import 'package:provider/provider.dart';

import 'state.dart';

class ChonkyDrawer extends StatelessWidget {
  ChonkyDrawer(this.home);

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
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Text('Drawer Header'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: buildGuildList(state),
              ),
              Expanded(
                child: state.channels == null ? Container() : buildChannelList(state),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildGuildList(MainState state) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: state.guilds == null ? 0 : state.guilds.length,
        itemBuilder: (BuildContext context, int index) {
          Guild g = state.guilds[index];
          return FutureBuilder(
              future: g.name,
              builder: (context, snapshot) {
                if (snapshot.hasData && !snapshot.hasError) {
                  String name = snapshot.data;
                  return Ink(
                      color: g.id == state.selectedChannel?.guildId ? Colors.pinkAccent : Colors.transparent,
                      child: ListTile(
                        title: Text(name),
                        onTap: () async {
                          if (g.id != state.selectedChannel?.guildId) {
                            await Provider.of<MainState>(context, listen: false).updateChannels(index);
                          }
                        },
                      ));
                } else {
                  return LinearProgressIndicator();
                }
              });
        });
  }

  Widget buildChannelList(MainState state) {
    return ListView.builder(
        shrinkWrap: true,
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
              ));
        });
  }

}