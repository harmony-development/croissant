import 'package:flutter/material.dart';
import 'package:harmony_sdk/harmony.dart';

class LoginArguments {
  final Homeserver server;

  LoginArguments(this.server);
}

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController(text: "eee@eee.eee");
  final passwordController = TextEditingController(text: "1Oopooo");

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LoginArguments args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text(
          "Login"
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Log into ${args.server.url}",
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
                  hintText: 'Password',
                ),
                obscureText: true,
                controller: passwordController,
              ),
            ),
            OutlineButton(
              child: Text("Login"),
              onPressed: () async {
                var client = Client(args.server);
                var resp = await client.login(emailController.text, passwordController.text);
              },
            )
          ],
        ),
      )
    );
  }
}
