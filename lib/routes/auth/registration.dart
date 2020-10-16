import 'package:flutter/material.dart';
import 'package:harmony_sdk/harmony.dart';
import 'package:winged_staccato/routes/main/main.dart';

class RegistrationArguments {
  final Homeserver server;

  RegistrationArguments(this.server);
}

class Registration extends StatefulWidget {
  Registration({Key key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final emailController = TextEditingController(text: "eee@eee.eee");
  final usernameController = TextEditingController(text: "leat_fingies");
  final passwordController = TextEditingController(text: "1Oopooo");

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final RegistrationArguments args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          title: Text(
              "Registration"
          ),
        ),
        body: Builder(
          builder: (context) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Registration on ${args.server.host}",
                  style: Theme.of(context).textTheme.headline4,
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Email',
                    ),
                    controller: emailController,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Username',
                    ),
                    controller: usernameController,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Password',
                    ),
                    obscureText: true,
                    controller: passwordController,
                  ),
                ),
                OutlineButton(
                  child: Text("Registration"),
                  onPressed: () async {
                    try {
                      await args.server.register(
                          usernameController.text, emailController.text,
                          passwordController.text);
                      Navigator.pushNamedAndRemoveUntil(context, '/main', (r) => false,  arguments: MainArguments(args.server));
                    } catch(e) {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("Registration: $e"),
                      ));
                    }
                  },
                )
              ],
            ),
          )
        )
    );
  }
}
