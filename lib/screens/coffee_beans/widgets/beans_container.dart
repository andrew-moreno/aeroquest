import 'package:aeroquest/providers/coffee_bean_provider.dart';
import 'package:aeroquest/widgets/card_header.dart';
import 'package:flutter/material.dart';
import 'package:aeroquest/constraints.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../coffee_beans.dart';

// template for the each coffee bean entry
// layout builder required for provider use
class BeansContainer extends StatelessWidget {
  const BeansContainer({
    Key? key,
    required this.formKey,
    required this.beanName,
    this.description,
    required this.id,
  }) : super(key: key);

  final GlobalKey<FormBuilderState> formKey;
  final String beanName;
  final String? description;
  final int id;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) => GestureDetector(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 7,
            horizontal: 15,
          ),
          decoration: BoxDecoration(
            color: kPrimary,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [kBoxShadow],
          ),
          child: CardHeader(
            title: beanName,
            description: description,
          ),
        ),
        onTap: () {
          showCustomModalSheet(
            submitAction: () {
              if (!formKey.currentState!.validate()) {
                return;
              }
              String beanName = formKey.currentState!.fields["beanName"]!.value;
              String? description =
                  formKey.currentState!.fields["description"]?.value;
              Provider.of<CoffeeBeanProvider>(context, listen: false)
                  .editBean(id, beanName, description);
              Navigator.of(context).pop();
            },
            deleteAction: () {
              Provider.of<CoffeeBeanProvider>(context, listen: false)
                  .deleteBean(id);
              Navigator.of(context).pop();
            },
            context: context,
            formKey: formKey,
            beanName: beanName,
            description: description,
            id: id,
          );
        },
      ),
    );
  }
}
