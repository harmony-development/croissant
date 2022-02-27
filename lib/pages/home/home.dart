import 'package:croissant/pages/home/widgets/channel_list.dart';
import 'package:croissant/pages/home/widgets/guild_list.dart';
import 'package:croissant/state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // these may need to be tweaked a little

    return SafeArea(child: LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 1200) {
        return buildLargeScreen(context);
      } else if (constraints.maxWidth > 800 && constraints.maxWidth < 1200) {
        return buildLargeScreen(context);
      } else {
        return buildSmallScreen(context);
      }
    }));
  }

  Widget buildLargeScreen(BuildContext context) {
    var selectedChannelId = Provider.of<CState>(context).selectedChannelId;

    var state = Provider.of<CState>(context, listen: false);
    state.isWideScreen = true;

    return Scaffold(
      body: Row(
        children: [
          const GuildList(),
          const ChannelList(),
          Expanded(
            child: Column(
              children: [
                AppBar(
                    title: selectedChannelId == null
                        ? const Text("Hello!")
                        : Text(state
                            .channels[state.selectedGuildId]![
                                selectedChannelId]!
                            .channelName)),
                const Center(child: Text("large screen")),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildSmallScreen(BuildContext context) {
    var selectedChannelId = Provider.of<CState>(context).selectedChannelId;

    var state = Provider.of<CState>(context, listen: false);
    state.isWideScreen = false;

    return Scaffold(
      appBar: AppBar(
          title: selectedChannelId == null
              ? const Text("Hello!")
              : Text(state.channels[state.selectedGuildId]![selectedChannelId]!
                  .channelName)),
      body: Column(
        children: const [
          Center(child: Text("small screen")),
        ],
      ),
      drawer: Drawer(
          child: Row(
        children: const [
          GuildList(),
          // todo: this overflows on some mobile devices / web
          ChannelList(),
        ],
      )),
    );
  }
}
