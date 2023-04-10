import 'package:aeroquest/models/coffee_bean.dart';
import 'package:aeroquest/providers/coffee_bean_provider.dart';
import 'package:aeroquest/widgets/card_header.dart';
import 'package:aeroquest/widgets/custom_card.dart';
import 'package:aeroquest/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../coffee_beans.dart';

class BeansContainer extends StatelessWidget {
  /// Container for each coffee bean entry
  const BeansContainer({
    Key? key,
    required this.formKey,
    required this.beanData,
  }) : super(key: key);

  /// Form key passed from [CoffeeBeans] that handles validation
  final GlobalKey<FormBuilderState> formKey;

  /// Coffee bean data associated with this entry
  final CoffeeBean beanData;

  @override
  Widget build(BuildContext context) {
    /// Used to warn the user that this coffee bean is associated with existing
    /// recipe variables
    ///
    /// Deletes all associated variables if the user confirms
    Future<void> _showDeleteDialog() async {
      return await showDialog(
        context: context,
        builder: (context) => CustomDialog(
          titleText: "Delete Associated Variables?",
          description:
              "This bean is associated with existing recipe variable sets. Do you want to delete these variable sets as well?",
          leftAction: () => Navigator.of(context).pop(false),
          rightAction: () {
            Provider.of<CoffeeBeanProvider>(context, listen: false).deleteBean(
              id: beanData.id!,
              deleteAssociatedVariables: true,
            );
            Navigator.of(context).pop();
          },
        ),
      );
    }

    /// Layout builder required for provider use
    return LayoutBuilder(
      builder: (_, __) => GestureDetector(
        child: CustomCard(
          child: CardHeader(
            title: beanData.beanName,
            description: beanData.description,
          ),
        ),
        onTap: () {
          showCustomCoffeeBeanModalSheet(
            submitAction: () {
              if (!formKey.currentState!.validate()) {
                return;
              }
              String beanName = formKey.currentState!.fields["beanName"]!.value;
              String? description =
                  formKey.currentState!.fields["description"]?.value;
              Provider.of<CoffeeBeanProvider>(context, listen: false).editBean(
                beanData.id!,
                beanName,
                description,
                beanData.associatedVariablesCount,
              );
              Navigator.of(context).pop();
            },
            deleteAction: () {
              Navigator.of(context).pop();
              if (beanData.associatedVariablesCount > 0) {
                _showDeleteDialog();
              } else {
                Provider.of<CoffeeBeanProvider>(context, listen: false)
                    .deleteBean(id: beanData.id!);
              }
            },
            context: context,
            formKey: formKey,
            beanName: beanData.beanName,
            description: beanData.description,
            autoFocusTitleField: false,
          );
        },
      ),
    );
  }
}
