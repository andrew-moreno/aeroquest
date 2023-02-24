import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import 'package:aeroquest/screens/coffee_beans/widgets/beans_container.dart';
import 'package:aeroquest/screens/coffee_beans/widgets/custom_beans_modal_sheet.dart';
import 'package:aeroquest/widgets/appbar/appbar_button.dart';
import 'package:aeroquest/widgets/appbar/appbar_leading.dart';
import 'package:aeroquest/widgets/appbar/appbar_text.dart';
import 'package:aeroquest/widgets/custom_drawer.dart';
import 'package:aeroquest/providers/coffee_bean_provider.dart';
import 'package:aeroquest/constraints.dart';

class CoffeeBeans extends StatefulWidget {
  /// The screen used for displaying all coffee beans
  const CoffeeBeans({Key? key}) : super(key: key);

  static const routeName = "/manageBeans";

  @override
  State<CoffeeBeans> createState() => _CoffeeBeansState();
}

class _CoffeeBeansState extends State<CoffeeBeans> {
  /// Form key used for validation of coffee bean names
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(leadingFunction: LeadingFunction.menu),
        title: const AppBarText(text: "COFFEE BEANS"),
        actions: [
          AppBarButton(
            onTap: () {
              showCustomCoffeeBeanModalSheet(
                submitAction: () {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }
                  String beanName =
                      _formKey.currentState!.fields["beanName"]!.value;
                  String? description =
                      _formKey.currentState!.fields["description"]?.value;
                  Provider.of<CoffeeBeanProvider>(context, listen: false)
                      .addBean(beanName, description);
                  Navigator.of(context).pop();
                },
                autoFocusTitleField: true,
                context: context,
                formKey: _formKey,
              );
            },
            icon: Icons.add,
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: SafeArea(
        child: FutureBuilder(
          future: Provider.of<CoffeeBeanProvider>(context, listen: false)
              .cacheCoffeeBeans(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Consumer<CoffeeBeanProvider>(
                builder: (_, coffeeBeanProvider, ___) {
                  return ListView.separated(
                    padding: const EdgeInsets.all(kRoutePagePadding),
                    itemCount: coffeeBeanProvider.coffeeBeans.length,
                    itemBuilder: (_, int index) {
                      int coffeeBeanId = coffeeBeanProvider.coffeeBeans.keys
                          .elementAt(coffeeBeanProvider.coffeeBeans.length -
                              index -
                              1);

                      return BeansContainer(
                        formKey: _formKey,
                        beanData: coffeeBeanProvider.coffeeBeans[coffeeBeanId]!,
                      );
                    },
                    separatorBuilder: (_, __) {
                      return const SizedBox(height: 20);
                    },
                  );
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: kAccent,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

/// Template for the modal bottom sheet when editing or adding bean entries
///
/// If [beanName] and [description] are input, they are set as the initial value
/// in the text fields
void showCustomCoffeeBeanModalSheet({
  required BuildContext context,
  required GlobalKey<FormBuilderState> formKey,
  required Function() submitAction,
  Function()? deleteAction,
  String? beanName,
  String? description,
  required bool autoFocusTitleField,
}) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius:
          BorderRadius.vertical(top: Radius.circular(kModalCornerRadius)),
    ),
    backgroundColor: kDarkSecondary,
    isScrollControlled: true,
    builder: (_) {
      return CustomBeansModalSheet(
        formKey: formKey,
        submitAction: submitAction,
        deleteAction: deleteAction,
        beanName: beanName,
        description: description,
        autoFocusTitleField: autoFocusTitleField,
      );
    },
  );
}
