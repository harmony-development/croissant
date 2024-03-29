import 'package:flutter/material.dart';
import 'package:harmony_sdk/harmony_sdk.dart' as sdk;

class FormItem extends StatelessWidget {

  final FieldController controller;

  const FormItem({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isObscure;
    if (controller.field.type.contains('password')) {
      isObscure = true;
    } else {
      isObscure = false;
    }

    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          decoration: InputDecoration(
            hintText: controller.field.name,
          ),
          obscureText: isObscure,
          controller: controller.text,
        ),
      );
  }

}

class FieldController {
  sdk.AuthStep_Form_FormField field;
  TextEditingController text;

  FieldController(this.field, this.text);
}
