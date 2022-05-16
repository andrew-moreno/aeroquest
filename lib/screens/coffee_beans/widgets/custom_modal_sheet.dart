import 'package:control_style/decorated_input_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:aeroquest/widgets/modal_button.dart';
import 'package:aeroquest/constraints.dart';

class CustomModalSheet extends StatelessWidget {
  const CustomModalSheet({
    Key? key,
    required formKey,
    required dynamic submitAction,
    dynamic deleteAction,
    String? beanName,
    String? description,
  })  : _formKey = formKey,
        _submitAction = submitAction,
        _deleteAction = deleteAction,
        _beanName = beanName,
        _description = description,
        super(key: key);

  final GlobalKey<FormBuilderState> _formKey;
  final dynamic _submitAction;
  final dynamic _deleteAction;
  final String? _beanName;
  final String? _description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20),
      child: FormBuilder(
        key: _formKey,
        child: LayoutBuilder(
          builder: (_, constraints) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomFormField(
                formName: "beanName",
                hint: "Name",
                autoFocus: true,
                validate: true,
                initialValue: _beanName,
              ),
              const Divider(height: 20, color: Color(0x00000000)),
              CustomFormField(
                formName: "description",
                hint: "Description",
                autoFocus: false,
                validate: false,
                initialValue: _description,
              ),
              const Divider(height: 20, color: Color(0x00000000)),
              Row(
                mainAxisAlignment: (_deleteAction != null)
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.center,
                children: [
                  ModalButton(
                    onTap: _submitAction,
                    buttonType: ButtonType.positive,
                    text: "Save",
                    width: constraints.maxWidth / 2 - 10,
                  ),
                  (_deleteAction != null)
                      ? ModalButton(
                          onTap: _deleteAction,
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
      decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          hintText: hint,
          hintStyle: const TextStyle(
            color: kPrimary,
            fontFamily: "Poppins",
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          filled: true,
          fillColor: kLightSecondary,
          border: DecoratedInputBorder(
            shadow: [kBoxShadow],
            child: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kCornerRadius),
              borderSide: BorderSide.none,
            ),
          )),
      validator: (value) {
        if (validate && (value == null || value.isEmpty)) {
          return "Please enter a name for these beans";
        }
      },
    );
  }
}
