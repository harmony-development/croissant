import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:harmony_sdk/harmony_sdk.dart' as sdk;
import 'package:winged_staccato/routes/auth/form_item.dart';

class FormWidget extends StatelessWidget {

  final sdk.Homeserver home;
  final String authId;
  final sdk.Form form;

  FormWidget({Key key, @required this.home, @required this.authId, @required this.form}) : super(key: key);

  List<FieldController> fieldControllers = new List();

  @override
  Widget build(BuildContext context) {
    final list = ListView.builder(
      shrinkWrap: true,
      itemCount: form.fields.length,
      itemBuilder: (BuildContext context, int index) {
        sdk.FormField field = form.fields[index];
        final controller = FieldController(field, TextEditingController());
        fieldControllers.add(controller);
        return FormItem(controller: controller,);
      },
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          form.title,
          style: Theme.of(context).textTheme.headline4,
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 100),
          child:list,
        ),
        RaisedButton(
          child: Text(
            "Let's GOOOOOO",
            style: Theme.of(context).textTheme.button,
          ),
          onPressed: () {
            var filledFields = fieldControllers.map((c) {
              if (c.field.type == 'email' || c.field.type == 'text')
                return sdk.StringField(c.text.text);
              if (c.field.type == 'password' || c.field.type == 'new-password')
                return sdk.BytesField(utf8.encode(c.text.text));
              if (c.field.type == 'number')
                return sdk.IntField(int.parse(c.text.text));
            }).toList();
            home.nextStepForm(authId, sdk.FilledForm(filledFields));
          },
          color: Theme.of(context).colorScheme.secondary,
        ),
    ],);
  }

}