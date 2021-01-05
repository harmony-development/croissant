import 'package:flutter/material.dart';
import 'package:harmony_sdk/harmony_sdk.dart';
import 'package:provider/provider.dart';

import 'state.dart';
import 'guilds_drawer.dart';
import 'members_drawer.dart';
import 'messages.dart';

class Main extends StatefulWidget {

  final Homeserver home;

  Main({Key key, @required this.home}) : super(key: key);

  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<Main> {

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MainState>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text(state.selectedChannel == null ? "Main!" : state.selectedChannel.name),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.people_rounded),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
        ],
      ),
      drawer: GuildsDrawer(widget.home),
      drawerEnableOpenDragGesture: false,
      endDrawer: state.selectedChannel == null ? null : MembersDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body: Builder(
        builder: (builderContext) => GestureDetector(
          onHorizontalDragEnd: (DragEndDetails details) {
            if (details.primaryVelocity > 0) {
              Scaffold.of(builderContext).openDrawer();
            } else if (details.primaryVelocity < 0 && state.selectedChannel != null) {
              Scaffold.of(builderContext).openEndDrawer();
            }
          },
          child: state.selectedChannel == null ? placeholder() :
          MessageList(state.selectedChannel),

        ),
      ),
    );
  }

  Widget placeholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Welcome to the club, buddy!',
            style: Theme.of(context).textTheme.headline4,
            textAlign: TextAlign.center,
          )
        ],
      )
    );
  }

}
