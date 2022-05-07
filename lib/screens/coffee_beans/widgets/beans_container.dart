import 'package:aeroquest/models/beans_provider.dart';
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
    required formKey,
    required beanName,
    description,
    required index,
  })  : _formKey = formKey,
        _beanName = beanName,
        _description = description,
        _index = index,
        super(key: key);

  final GlobalKey<FormBuilderState> _formKey;
  final String _beanName;
  final String? _description;
  final int _index;

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
            title: widget._beanName,
            description: widget._description,
          ),
        ),
        onTap: () {
          showCustomModalSheet(
            submitAction: () {
              if (!widget._formKey.currentState!.validate()) {
                return;
              }
              String beanName =
                  widget._formKey.currentState!.fields["beanName"]!.value;
              String? description =
                  widget._formKey.currentState!.fields["description"]?.value;
              Provider.of<BeansProvider>(builderContext, listen: false)
                  .editBean(beanName, description, widget._index);
              Navigator.of(context).pop();
            },
            deleteAction: () {
              Provider.of<BeansProvider>(builderContext, listen: false)
                  .deleteBean(widget._index);
              Navigator.of(context).pop();
            },
            context: builderContext,
            formKey: widget._formKey,
            beanName: widget._beanName,
            description: widget._description,
            index: widget._index,
          );
        },
      ),
    );
  }
}
