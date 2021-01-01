import 'package:flutter/material.dart';
import 'package:harmony_sdk/harmony_sdk.dart';

class InviteDialog extends StatefulWidget {
  InviteDialog(this.home);

  final Homeserver home;
  
  @override
  _InviteDialogState createState() => _InviteDialogState();
}

class _InviteDialogState extends State<InviteDialog> {
  final inviteLinkController = TextEditingController();
  bool _isButtonEnabled;

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
      title: Text("Join guild"),
      content: TextField(
        decoration: InputDecoration(
          hintText: 'Invite Link',
        ),
        controller: inviteLinkController,
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('CANCEL'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        _isButtonEnabled ? RaisedButton(
            child: Text('JOIN GUILD'),
            onPressed: () async {
              setState(() {
                _isButtonEnabled = false;
              });
              final link = inviteLinkController.text;
              Server server;
              String inviteId;
              if (link.startsWith('harmony://')) {
                var cleanLink = link.replaceAll('harmony://', '');
                var parts = cleanLink.split('/');
                server = Server(parts[0]);
                inviteId = parts[1];
              } else {
                server = widget.home;
                inviteId = link;
              }

              try {
                await server.joinGuild(inviteId);
                Navigator.of(context).pop();
              } catch(e) {
                setState(() {
                  _isButtonEnabled = true;
                });
              }
            }
        ) :
        FlatButton(
          child: Text('JOIN GUILD'),
          color: Colors.grey,
        )
      ],
    );
  }

}