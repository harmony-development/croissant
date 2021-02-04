import 'dart:async';

import 'package:flutter/material.dart';
import 'package:harmony_sdk/harmony_sdk.dart' as sdk;
import 'package:hive/hive.dart';
import 'package:winged_staccato/routes/auth/choice.dart';
import 'package:winged_staccato/routes/auth/form.dart';
import 'package:winged_staccato/routes/auth/waiting.dart';
import 'package:winged_staccato/routes/hive.dart';
import 'package:winged_staccato/routes/main/main.dart';

class Auth extends StatefulWidget {

  final sdk.Homeserver home;

  Auth({Key key, @required this.home}) : super(key: key);

  @override
  _AuthState createState() => _AuthState();

}

class _AuthState extends State<Auth> {

  String _authId;
  StreamSubscription<sdk.AuthStep> _sub;
  sdk.AuthStep _step;

  @override void dispose() {
    try {
      _sub.cancel();
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
    final String authId = await widget.home.beginAuth();
    try {
      StreamSubscription<sdk.AuthStep> sub = widget.home.streamSteps(authId).listen((event) {
        setState(() => _step = event);
      });
      sdk.AuthStep step = await widget.home.getFirstStep(authId);
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
    if (_step == null)
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          title: Text(
              "Authentication"
          ),
        ),
        body: Center(
            child: Center(child: CircularProgressIndicator(),)
        ),
      );

    Widget stepWidget;
    if (_step is sdk.Choice)
      stepWidget = ChoiceWidget(home: widget.home, authId: _authId, choice: _step);
    if (_step is sdk.Form)
      stepWidget = FormWidget(home: widget.home, authId: _authId, form: _step);
    if (_step is sdk.Waiting)
      stepWidget = WaitingWidget(waiting: _step,);
    if (_step is sdk.SessionStep) {
      Future.delayed(Duration.zero, () => saveSession((_step as sdk.SessionStep).session)); // execute after build
      stepWidget = CircularProgressIndicator();
    }

    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text(
            "Authentication"
        ),
      ),
      body: Center(
          child: stepWidget
      ),
    ), onWillPop: () async {
      if (_step.canGoBack) {
        await widget.home.stepBack(_authId);
        return false;
      } else
        return true;
    });
  }

  Future<void> saveSession(sdk.Session session) async {
    if (!Hive.isBoxOpen('box')) {
      await HiveUtils.superInit();
    }
    final box = Hive.box('box');
    if (box.isNotEmpty) {
      await box.clear();
    }
    final cred = Credentials(widget.home.host, session.token, session.userId);
    await box.add(cred);
    widget.home.session = session;
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
      builder: (context) => Main(home: widget.home,),
    ), (r) => false);
  }

}