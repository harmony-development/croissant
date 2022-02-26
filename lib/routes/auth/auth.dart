import 'dart:async';

import 'package:croissant/routes/utils.dart';
import 'package:flutter/material.dart';
import 'package:harmony_sdk/harmony_sdk.dart' as sdk;
import 'package:croissant/routes/auth/choice.dart';
import 'package:croissant/routes/auth/form.dart';
import 'package:croissant/routes/auth/waiting.dart';
import 'package:croissant/routes/main/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth extends StatefulWidget {

  final sdk.Client client;

  const Auth({Key? key, required this.client}) : super(key: key);

  @override
  _AuthState createState() => _AuthState();

}

class _AuthState extends State<Auth> {

  String? _authId;
  StreamSubscription<sdk.StreamStepsResponse>? _sub;
  sdk.AuthStep? _step;

  @override void dispose() {
    try {
      _sub?.cancel();
    } catch (e, trace) {
      print("error disposing AuthState ($_sub): $e");
      print("the trace: $trace");
    } finally {
      super.dispose();
    }
  }

  @override
  void initState() {
    super.initState();
    initAuth();
  }
  
  Future<void> initAuth() async {
    final sdk.BeginAuthResponse response = await widget.client.BeginAuth(sdk.BeginAuthRequest());
    final String authId = response.authId;
    try {
      StreamSubscription<sdk.StreamStepsResponse> sub = widget.client.StreamSteps(sdk.StreamStepsRequest(authId: authId)).listen((event) {
        setState(() => _step = event.step);
      });
      sdk.NextStepResponse firstStep = await widget.client.NextStep(sdk.NextStepRequest(authId: authId));
      sdk.AuthStep step = firstStep.step;
      setState(() {
        _authId = authId;
        _sub = sub;
        _step = step;
      });
    } catch (e, trace) {
      print("exception happened when initting auth: $e");
      print("its trace: $trace");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_step == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          title: const Text(
              "Authentication"
          ),
        ),
        body: const Center(
            child: Center(child: CircularProgressIndicator(),)
        ),
      );
    }

    Widget? stepWidget;
    switch (_step?.whichStep()) {
      case sdk.AuthStep_Step.choice:
        stepWidget = ChoiceWidget(client: widget.client, authId: _authId!, choice: _step!.choice);
        break;
      case sdk.AuthStep_Step.form:
        stepWidget = FormWidget(client: widget.client, authId: _authId!, form: _step!.form);
        break;
      case sdk.AuthStep_Step.waiting:
        stepWidget = WaitingWidget(waiting: _step!.waiting,);
        break;
      case sdk.AuthStep_Step.session:
        Future.delayed(Duration.zero, () => saveSession(_step!.session)); // execute after build
        stepWidget = const CircularProgressIndicator();
        break;
      default:
    }

    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: const Text(
            "Authentication"
        ),
      ),
      body: Center(
          child: stepWidget
      ),
    ), onWillPop: () async {
      if (_step?.canGoBack ?? false) {
        await widget.client.StepBack(sdk.StepBackRequest(authId: _authId));
        return false;
      } else {
        return true;
      }
    });
  }

  Future<void> saveSession(sdk.Session session) async {
    var storage = PersistentStorage();
    storage.host = widget.client.server.toString();
    storage.token = session.sessionToken;
    storage.userId = session.userId;
    await storage.save();

    widget.client.setToken(session);
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
      builder: (context) => Main(client: widget.client),
    ), (route) => false);
  }

}
