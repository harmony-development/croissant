import 'package:croissant/pages/settings/settings.dart';
import 'package:croissant/state.dart';
import 'package:croissant/theme/croissant_dark.dart';
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
            InkWell(
              child: AppBar(
                title: selectedGuildId == null
                ? const Text("private channels", style: TextStyle(fontSize: 14))
                : Row(
                  children: [
                    Text(state.guilds[selectedGuildId]!.name, style: const TextStyle(fontSize: 14)),
                    const Expanded(
                      child: Icon(Icons.arrow_drop_down),
                    ),
                  ],
                ),
                centerTitle: true,
                backgroundColor: const Color(0xFF171627),
              ),
              onTap: () {
                if (state.isWideScreen) {
                  showDialog(context: context, builder: (context) => const SettingsPage());
                } else {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
                }
              },
            ),
            ...state.channels[selectedGuildId] == null
              ? [const Text("not implemented yet (:")]
              : state.channels[selectedGuildId]!.keys.map<Padding>((channel) =>
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 4),
                child: SizedBox(
                  width: 250,
                  child: ElevatedButton(
                    onPressed: () => state.selectedChannelId = channel,
                    style: ElevatedButton.styleFrom(
                      primary: state.selectedChannelId == channel 
                        ? const Color(0xFF414052)
                        : const Color(CroissantDark.backgroundPrimary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 4),
                              child: Icon(Icons.tag, color: Color(0x88ffffff), size: 18)
                            ),
                            Text(
                              state.channels[selectedGuildId]![channel]!.channelName,
                              style: const TextStyle(color: Color(0xffffffff)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ).toList(),
          ],
        ),
      ),
      width: 225,
    );
  }

}