import 'package:flutter/material.dart';
import 'package:harmony_sdk/harmony_sdk.dart';

class WaitingWidget extends StatelessWidget {

  final AuthStep_Waiting waiting;

  const WaitingWidget({Key? key, required this.waiting}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(
        waiting.title,
        style: Theme.of(context).textTheme.headline4,
        textAlign: TextAlign.center,
      ),
      Text(
        waiting.description,
        style: Theme.of(context).textTheme.headline6,
        textAlign: TextAlign.center,
      ),
    ],);
  }

}