import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:aeroquest/constraints.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField({
    Key? key,
    required this.formName,
    required this.hint,
    required this.autoFocus,
    required this.validate,
    required this.initialValue,
  }) : super(key: key);

  final String formName;
  final String hint;
  final bool autoFocus;
  final bool validate;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      cursorColor: kPrimary,
      cursorWidth: 1,
      name: formName,
      initialValue: initialValue,
      style: const TextStyle(color: kPrimary, fontSize: 16),
      autofocus: autoFocus,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        hintText: hint,
        hintStyle: const TextStyle(
          color: kPrimary,
          fontFamily: "Poppins",
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kCornerRadius),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: kLightSecondary,
      ),
      validator: (value) {
        if (validate && (value == null || value.isEmpty)) {
          return "Please enter a name for these beans";
        }
      },
    );
  }
}
