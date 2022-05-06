import 'package:flutter/material.dart';
import 'package:aeroquest/constraints.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';

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
    return Container(
      decoration: BoxDecoration(
        boxShadow: [kBoxShadow],
        color: kLightSecondary,
        borderRadius: BorderRadius.circular(
          kCornerRadius,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: FormBuilderTextField(
        cursorColor: kPrimary,
        cursorWidth: 1,
        name: formName,
        initialValue: initialValue,
        style: const TextStyle(color: kPrimary, fontSize: 16),
        autofocus: autoFocus,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(
            color: kPrimary,
            fontFamily: "Poppins",
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        validator: (value) {
          if (validate && (value == null || value.isEmpty)) {
            return "Please enter a name for these beans";
          }
        },
      ),
    );
  }
}
