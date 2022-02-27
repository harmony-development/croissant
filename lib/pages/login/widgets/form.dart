import 'dart:convert';
import 'package:fixnum/fixnum.dart';

import 'package:flutter/material.dart';
import 'package:harmony_sdk/harmony_sdk.dart' as sdk;
import 'package:croissant/pages/login/widgets/form_item.dart';

class FormWidget extends StatelessWidget {

  final sdk.Client client;
  final String authId;
  final sdk.AuthStep_Form form;

  FormWidget({Key? key, required this.client, required this.authId, required this.form}) : super(key: key);

  List<FieldController> fieldControllers = [];

  @override
  Widget build(BuildContext context) {
    final list = ListView.builder(
      shrinkWrap: true,
      itemCount: form.fields.length,
      itemBuilder: (BuildContext context, int index) {
        sdk.AuthStep_Form_FormField field = form.fields[index];
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
          padding: const EdgeInsets.symmetric(horizontal: 100),
          child:list,
        ),
        RaisedButton(
          child: Text(
            "Submit",
            style: Theme.of(context).textTheme.button,
          ),
          onPressed: () {
            var filledFields = fieldControllers.map((c) {
              if (c.field.type == 'password' || c.field.type == 'new-password') {
                return sdk.NextStepRequest_FormFields(bytes: utf8.encode(c.text.text));
              }
              if (c.field.type == 'number') {
                return sdk.NextStepRequest_FormFields(number: Int64(int.parse(c.text.text)));
              }
              return sdk.NextStepRequest_FormFields(string: c.text.text);
            }).toList();
            client.NextStep(sdk.NextStepRequest(authId: authId, form: sdk.NextStepRequest_Form(fields: filledFields)));
          },
          color: Theme.of(context).colorScheme.secondary,
        ),
    ],);
  }

}
