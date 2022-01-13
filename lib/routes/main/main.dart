import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:harmony_sdk/harmony_sdk.dart';
import 'package:provider/provider.dart';

import 'state.dart';
import 'guilds_drawer.dart';
import 'members_drawer.dart';
import 'messages.dart';

class Main extends StatefulWidget {

  final Client client;

  Main({Key? key, required this.client}) : super(key: key);

  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<Main> with SingleTickerProviderStateMixin {

  late Widget _guildsDrawer;
  Widget _membersDrawer = MembersDrawer();

  @override
  void initState() {
    _guildsDrawer = GuildsDrawer(widget.client);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MainState>(context);

    return InnerDrawer(
      key: _innerDrawerKey,
      onTapClose: true, // default false
      swipe: true, // default true
      swipeChild: true,

      // colorTransitionChild: Colors.black54,
      colorTransitionScaffold: Colors.black54, // default Color.black54

      offset: const IDOffset.only(right: 0.8, left: 0.8),

      proportionalChildArea : true, // default true
      borderRadius: 20, // default 0

      leftChild: _guildsDrawer,
      rightChild: state.selectedChannelId == null ? const Drawer() : _membersDrawer,
      scaffold: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).backgroundColor,
          title: Text(state.selectedChannel?.channel.channelName ?? "Main!"),
          leading: GestureDetector(
            onTap: () { _toggleGuilds(); },
            child: const Icon(
              Icons.menu,  // add custom icons also
            ),
          ),
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.people_rounded),
                onPressed: () => _toggleMembers(),
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              ),
            ),
          ],
        ),
        body: Builder(
          builder: (builderContext) => state.selectedChannel == null ? placeholder() :
          MessageList(widget.client, state.selectedChannel!),
        ),
      )
    );
  }

  //  Current State of InnerDrawerState
  final GlobalKey<InnerDrawerState> _innerDrawerKey = GlobalKey<InnerDrawerState>();

  void _toggleGuilds()
  {
    _innerDrawerKey.currentState?.toggle(
        direction: InnerDrawerDirection.start
    );
  }

  void _toggleMembers()
  {
    _innerDrawerKey.currentState?.toggle(
      direction: InnerDrawerDirection.end
    );
  }

  Widget placeholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
