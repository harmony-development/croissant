import 'package:flutter/material.dart';
import 'package:harmony_sdk/harmony_sdk.dart';

class InviteDialog extends StatefulWidget {
  InviteDialog(this.client);

  final Client client;
  
  @override
  _InviteDialogState createState() => _InviteDialogState();
}

class _InviteDialogState extends State<InviteDialog> {
  final inviteLinkController = TextEditingController();
  late bool _isButtonEnabled;

  @override
  void initState() {
    _isButtonEnabled = false;
    inviteLinkController.addListener(() {
      if (inviteLinkController.text.isEmpty && _isButtonEnabled) {
        setState(() {
          _isButtonEnabled = false;
        });
      }
      if (inviteLinkController.text.isNotEmpty && !_isButtonEnabled) {
        setState(() {
          _isButtonEnabled = true;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    inviteLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Join guild"),
      content: TextField(
        decoration: const InputDecoration(
          hintText: 'Invite Link',
        ),
        controller: inviteLinkController,
      ),
      actions:[
        FlatButton(
          child: const Text('CANCEL'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        _isButtonEnabled ? RaisedButton(
            child: const Text('JOIN GUILD'),
            onPressed: () async {
              setState(() {
                _isButtonEnabled = false;
              });
              final link = inviteLinkController.text;
              String inviteId;
              Client client = widget.client;
              if (link.startsWith('harmony://')) {
                var cleanLink = link.replaceAll('harmony://', '');
                var parts = cleanLink.split('/');
                AutoFederateClient server = AutoFederateClient(widget.client.server);
                client = await server.clientFor(Uri.parse(parts[0]));
                inviteId = parts[1];
              } else {
                inviteId = link;
              }

              try {
                await client.JoinGuild(JoinGuildRequest(inviteId: inviteId));
                Navigator.of(context).pop();
              } catch(e) {
                setState(() {
                  _isButtonEnabled = true;
                });
              }
            }
        ) :
        FlatButton(
          child: const Text('JOIN GUILD'),
          color: Colors.grey,
          onPressed: () {},
        )
      ],
    );
  }

}
