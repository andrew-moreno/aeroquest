import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/providers/coffee_bean_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class CustomFormField extends StatelessWidget {
  /// Defines the widget for a styled text field
  const CustomFormField({
    Key? key,
    required this.formName,
    required this.hint,
    this.autoFocus = false,
    this.validate = false,
    this.validateUniqueness = false,
    this.validateText,
    required this.textCapitalization,
    required this.initialValue,
  }) : super(key: key);

  final String formName;
  final String hint;
  final bool autoFocus;

  /// Whether to do a validation check on the entered text or not
  final bool validate;

  /// Text to be displayed if the validation fails
  final String? validateText;
  final String? initialValue;

  /// Whether to check if the entered text already exists within the app
  final bool validateUniqueness;

  /// Type of text capitalization to use in the form field
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      textCapitalization: textCapitalization,
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
        } else if (validateUniqueness) {
          if (value != initialValue &&
              Provider.of<CoffeeBeanProvider>(context, listen: false)
                  .coffeeBeans
                  .values
                  .any((coffeeBean) => coffeeBean.beanName == value)) {
            return "Please select a unique coffee bean name";
          }
        }
        return null;
      },
    );
  }
}
