import 'package:aeroquest/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:aeroquest/widgets/custom_button.dart';

class CustomBeansModalSheet extends StatelessWidget {
  const CustomBeansModalSheet({
    Key? key,
    required this.formKey,
    required this.submitAction,
    this.deleteAction,
    this.beanName,
    this.description,
    required this.autoFocusTitleField,
  }) : super(key: key);

  /// Form key passed from [CoffeeBeans] that handles validation
  final GlobalKey<FormBuilderState> formKey;

  /// Function that is executed when the user clicks 'Save'
  final Function() submitAction;

  /// Function that is executed when the user clicks 'Delete'
  final Function()? deleteAction;

  /// Coffee bean name to use as an initial value
  ///
  /// If null, the associated text field will remain empty
  final String? beanName;

  /// Coffee bean description to use as an initial value
  ///
  /// If null, the associated text field will remain empty
  final String? description;

  /// Whether to autofocus the title form field or not when opening the modal
  final bool autoFocusTitleField;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20),
      child: FormBuilder(
        key: formKey,
        child: LayoutBuilder(
          builder: (_, constraints) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomFormField(
                formName: "beanName",
                hint: "Name",
                autoFocus: autoFocusTitleField,
                validate: true,
                initialValue: beanName,
                validateText: "Please enter a name for these coffee beans",
                validateUniqueness: true,
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 20),
              CustomFormField(
                formName: "description",
                hint: "Description",
                initialValue: description,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: (deleteAction != null)
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.center,
                children: [
                  CustomButton(
                    onTap: submitAction,
                    buttonType: ButtonType.vibrant,
                    text: "Save",
                    width: constraints.maxWidth / 2 - 10,
                  ),
                  (deleteAction != null)
                      ? CustomButton(
                          onTap: deleteAction!,
                          buttonType: ButtonType.normal,
                          text: "Delete",
                          width: constraints.maxWidth / 2 - 10,
                        )
                      : Container(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
