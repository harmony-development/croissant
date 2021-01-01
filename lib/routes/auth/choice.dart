import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harmony_sdk/harmony_sdk.dart';

class ChoiceWidget extends StatelessWidget {

  final Homeserver home;
  final String authId;
  final Choice choice;

  ChoiceWidget({Key key, @required this.home, @required this.authId, @required this.choice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          choice.title,
          style: Theme.of(context).textTheme.headline4,
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 100),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: choice.options.length,
            itemBuilder: (BuildContext context, int index) {
              String option = choice.options[index];
              return ListTile(
                title: Text(option),
                contentPadding: EdgeInsets.symmetric(vertical: 16),
                trailing: Icon(Icons.arrow_right),
                onTap: () {
                  home.nextStepChoice(authId, FilledChoice(choice.options[index]));
                },
              );
            },
          ),
        ),
    ],);
  }

}