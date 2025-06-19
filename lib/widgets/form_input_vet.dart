import 'package:flutter/material.dart';

class InputFieldVetText extends StatelessWidget {
  const InputFieldVetText(
      {super.key,
      required this.inputLabel,
      required this.inputHint,
      required this.maxmumlength,
      required this.textType,
      required this.obscureText,
      required this.theController,
      required this.validation});

  final TextEditingController theController;
  final int maxmumlength;
  final String inputHint;
  final String inputLabel;
  final TextInputType textType;
  final String? Function(String? value)? validation;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        maxLength: maxmumlength,
        controller: theController,
        keyboardType: textType,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: inputHint,
          label: Text(inputLabel),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(2))),
        ),
        validator: validation);
  }
}
