import 'package:aeroquest/widgets/modal_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'custom_form_field.dart';

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
