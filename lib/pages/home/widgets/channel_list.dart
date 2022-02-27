
import 'package:croissant/state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChannelList extends StatelessWidget {
  const ChannelList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var selectedGuildId = Provider.of<CState>(context).selectedGuildId;

    var state = Provider.of<CState>(context, listen: false);

    return SizedBox(
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF171627),
        ),
        child: Column(
          children: [
            // todo: have guild settings or something
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 8, bottom: 4, right: 4),
              child: selectedGuildId == null ? const Text("private channels") : Text(state.guilds[selectedGuildId]!.name),
            ),
            const Divider(),
            ...state.channels[selectedGuildId] == null
              ? [const Text("hi")]
              : state.channels[selectedGuildId]!.keys.map<InkWell>((channel) =>
              InkWell(
                child: Text(state.channels[selectedGuildId]![channel]!.channelName),
                onTap: () => state.selectedChannelId = channel,
              )
            ).toList(),
          ]
        ),
      ),
      width: 225,
    );
  }

}