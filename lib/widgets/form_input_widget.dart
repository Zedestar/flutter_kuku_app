import 'package:flutter/material.dart';

class FormInputWidget extends StatelessWidget {
  const FormInputWidget({
    super.key,
    required this.inputLabel,
    required this.inputHint,
    required this.maxmumlength,
    required this.textType,
    required this.theController,
  });

  final TextEditingController theController;
  final int maxmumlength;
  final String inputHint;
  final String inputLabel;
  final TextInputType textType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxmumlength,
      controller: theController,
      keyboardType: textType,
      decoration: InputDecoration(
          hintText: inputHint,
          label: Text(inputLabel),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)))),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "This field can not be empty";
        }
        return null;
      },
    );
  }
}
