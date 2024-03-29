import 'package:flutter/material.dart';
import 'package:harmony_sdk/harmony_sdk.dart';

class ChoiceWidget extends StatelessWidget {

  final Client client;
  final String authId;
  final AuthStep_Choice choice;

  const ChoiceWidget({Key? key, required this.client, required this.authId, required this.choice}) : super(key: key);

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
          padding: const EdgeInsets.symmetric(horizontal: 100),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: choice.options.length,
            itemBuilder: (BuildContext context, int index) {
              String option = choice.options[index];
              return ListTile(
                title: Text(option),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                trailing: const Icon(Icons.arrow_right),
                onTap: () {
                  client.NextStep(NextStepRequest(authId: authId, choice: NextStepRequest_Choice(choice: choice.options[index])));
                },
              );
            },
          ),
        ),
    ],);
  }

}
