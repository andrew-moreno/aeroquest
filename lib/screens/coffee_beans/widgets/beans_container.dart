import 'package:aeroquest/providers/coffee_bean_provider.dart';
import 'package:aeroquest/widgets/card_header.dart';
import 'package:flutter/material.dart';
import 'package:aeroquest/constraints.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../coffee_beans.dart';

// template for the each coffee bean entry
// layout builder required for provider use
class BeansContainer extends StatefulWidget {
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
  State<BeansContainer> createState() => _BeansContainerState();
}

class _BeansContainerState extends State<BeansContainer> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (builderContext, constraints) => GestureDetector(
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
            title: widget.beanName,
            description: widget.description,
          ),
        ),
        onTap: () {
          showCustomModalSheet(
            submitAction: () {
              if (!widget.formKey.currentState!.validate()) {
                return;
              }
              String beanName =
                  widget.formKey.currentState!.fields["beanName"]!.value;
              String? description =
                  widget.formKey.currentState!.fields["description"]?.value;
              Provider.of<CoffeeBeanProvider>(builderContext, listen: false)
                  .editBean(widget.id, beanName, description);
              Navigator.of(context).pop();
            },
            deleteAction: () {
              Provider.of<CoffeeBeanProvider>(builderContext, listen: false)
                  .deleteBean(widget.id);
              Navigator.of(context).pop();
            },
            context: builderContext,
            formKey: widget.formKey,
            beanName: widget.beanName,
            description: widget.description,
            id: widget.id,
          );
        },
      ),
    );
  }
}
