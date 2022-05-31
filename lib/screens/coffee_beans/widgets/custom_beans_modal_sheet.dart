import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:aeroquest/widgets/modal_button.dart';
import 'package:aeroquest/constraints.dart';

class CustomBeansModalSheet extends StatelessWidget {
  const CustomBeansModalSheet({
    Key? key,
    required this.formKey,
    required this.submitAction,
    this.deleteAction,
    this.beanName,
    this.description,
  }) : super(key: key);

  final GlobalKey<FormBuilderState> formKey;
  final Function() submitAction;
  final Function()? deleteAction;
  final String? beanName;
  final String? description;

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
                autoFocus: true,
                validate: true,
                initialValue: beanName,
              ),
              const Divider(height: 20, color: Color(0x00000000)),
              CustomFormField(
                formName: "description",
                hint: "Description",
                autoFocus: false,
                validate: false,
                initialValue: description,
              ),
              const Divider(height: 20, color: Color(0x00000000)),
              Row(
                mainAxisAlignment: (deleteAction != null)
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.center,
                children: [
                  ModalButton(
                    onTap: submitAction,
                    buttonType: ButtonType.positive,
                    text: "Save",
                    width: constraints.maxWidth / 2 - 10,
                  ),
                  (deleteAction != null)
                      ? ModalButton(
                          onTap: deleteAction!,
                          buttonType: ButtonType.negative,
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
      decoration: InputDecoration(hintText: hint),
      validator: (value) {
        if (validate && (value == null || value.isEmpty)) {
          return "Please enter a name for these beans";
        }
        return null;
      },
    );
  }
}
