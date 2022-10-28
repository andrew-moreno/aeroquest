import 'package:aeroquest/constraints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField({
    Key? key,
    required this.formName,
    required this.hint,
    this.autoFocus = false,
    this.validate = false,
    this.validateText,
    required this.initialValue,
  }) : super(key: key);

  final String formName;
  final String hint;
  final bool autoFocus;
  final bool validate;
  final String? validateText;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      maxLines: null,
      cursorColor: kPrimary,
      cursorWidth: 1,
      name: formName,
      initialValue: initialValue,
      style: const TextStyle(color: kPrimary, fontSize: 16),
      autofocus: autoFocus,
      decoration: InputDecoration(hintText: hint),
      validator: (value) {
        if (validate && (value == null || value.isEmpty)) {
          if (validateText == null) {
            throw Exception("validateText needs a value when validating");
          }
          return validateText;
        }
        return null;
      },
    );
  }
}
