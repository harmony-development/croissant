import 'package:croissant/pages/settings/settings.dart';
import 'package:croissant/state.dart';
import 'package:flutter/material.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:provider/provider.dart';

class GuildList extends StatelessWidget {
  const GuildList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var guilds = Provider.of<CState>(context).guilds;

    var state = Provider.of<CState>(context, listen: false);

    // todo: put the tooltip into its own separate widget

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF121220),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 16, bottom: 8, right: 4),
            child: JustTheTooltip(
              child: InkWell(
                child: const Icon(Icons.people),
                onTap: () => state.selectedGuildId = null,
              ),
              content: const Padding(
                padding: EdgeInsets.all(4),
                child: Text("Direct Message"),
              ),
              preferredDirection: AxisDirection.right,
              tailBuilder: (_, __, ___) { return Path()..close(); },
            )
          ),
          const Divider(),
          ...guilds.keys.map((x) => Padding(
            padding: const EdgeInsets.all(4),
            child: JustTheTooltip(
              child: InkWell(
                child: CircleAvatar(
                  foregroundImage: Image.network("https://cdn.discordapp.com/emojis/942588440413863956.webp?size=96&quality=lossless").image,
                ),
                onTap: () => state.selectedGuildId = x,
              ),
              content: Padding(
                padding: const EdgeInsets.all(4),
                child: Text(guilds[x]!.name)
              ),
              preferredDirection: AxisDirection.right,
              tailBuilder: (_, __, ___) { return Path()..close(); },
            )
          )).toList(),
          Padding(
            padding: const EdgeInsets.all(4),
            child: JustTheTooltip(
              child: InkWell(
                child: const Icon(Icons.add),
                onTap: () { },
              ),
              content: const Padding(
                padding: EdgeInsets.all(4),
                child: Text("Join guild")
              ),
              preferredDirection: AxisDirection.right,
              tailBuilder: (_, __, ___) { return Path()..close(); },
            )
          ),
          const Expanded(child: SizedBox()),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 8, bottom: 16, right: 4),
            child: JustTheTooltip(
              child: InkWell(
                child: const Icon(Icons.person),
                onTap: () {
                  if (state.isWideScreen) {
                    showDialog(context: context, builder: (context) => const SettingsPage());
                  } else {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
                  }
                },
              ),
              content: const Padding(
                padding: EdgeInsets.all(4),
                child: Text("User settings")
              ),
              preferredDirection: AxisDirection.right,
              tailBuilder: (_, __, ___) { return Path()..close(); },
            )
          ),
        ],
      ),
      width: 80,
      height: MediaQuery.of(context).size.height
    );
  }  
}