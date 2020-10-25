import 'package:flutter/material.dart';
import 'package:harmony_sdk/harmony.dart';
import 'package:winged_staccato/main.dart';
import 'package:winged_staccato/routes/main/messages.dart';

class Main extends StatefulWidget {
  Main({Key key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {

  List<Guild> guilds;
  Guild selectedGuild;
  List<Channel> channels;
  Channel selectedChannel;

  Homeserver home;

  @override
  Widget build(BuildContext context) {
    if (home == null) {
      final HomeserverArguments args = ModalRoute.of(context).settings.arguments;
      home = args.home;
    }

    final gwidget = queryGuilds();
    final cwidget = selectedGuild == null ? Container() : queryChannels();
    final bwidget = buildBody();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text("Main!"),
      ),
      drawer: Drawer(
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
                  child: gwidget,
                ),
                Expanded(
                  child: cwidget,
                ),
              ],
            ),
          ],
        ),
      ),
      body: bwidget,
    );
  }

  Widget buildBody() {
    final content = selectedGuild == null
        ? Text(
            'Welcome to the club, buddy!',
            style: Theme.of(context).textTheme.headline4,
            textAlign: TextAlign.center,
          )
        : Text(
            'Select channel',
            style: Theme.of(context).textTheme.headline4,
            textAlign: TextAlign.center,
          );
    return selectedChannel == null
        ? Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[content],
          ))
        : MessageList(selectedChannel);
  }

  Widget queryGuilds() {
    return FutureBuilder(
      future: home.joinedGuilds(),
      builder: (context, snapshot) {
        if (snapshot.hasData && !snapshot.hasError) {
          guilds = snapshot.data;
          return buildGuildList(guilds);
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget buildGuildList(List<Guild> guilds) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: guilds == null ? 0 : guilds.length,
        itemBuilder: (BuildContext context, int index) {
          Guild g = guilds[index];
          return FutureBuilder(
              future: g.name,
              builder: (context, snapshot) {
                if (snapshot.hasData && !snapshot.hasError) {
                  String name = snapshot.data;
                  return Ink(
                      color: g.id == selectedGuild?.id ? Colors.pinkAccent : Colors.transparent,
                      child: ListTile(
                        title: Text(name),
                        onTap: () {
                          setState(() {
                            selectedGuild = g;
                            selectedChannel = null;
                          });
                        },
                      ));
                } else {
                  return LinearProgressIndicator();
                }
              });
        });
  }

  Widget queryChannels() {
    return FutureBuilder(
      future: home.listChannels(selectedGuild.id),
      builder: (context, snapshot) {
        if (snapshot.hasData && !snapshot.hasError) {
          channels = snapshot.data;
          return buildChannelList(channels);
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget buildChannelList(List<Channel> channels) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: channels == null ? 0 : channels.length,
        itemBuilder: (BuildContext context, int index) {
          Channel c = channels[index];
          return Ink(
              color: c.id == selectedChannel?.id ? Colors.pinkAccent : Colors.transparent,
              child: ListTile(
                title: Text(c.name),
                onTap: () {
                  setState(() {
                    selectedChannel = c;
                  });
                },
              ));
        });
  }

}
