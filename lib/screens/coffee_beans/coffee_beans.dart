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
  const CoffeeBeans({Key? key}) : super(key: key);

  static const routeName = "/manageBeans";

  @override
  State<CoffeeBeans> createState() => _CoffeeBeansState();
}

class _CoffeeBeansState extends State<CoffeeBeans> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(function: LeadingFunction.menu),
        title: const AppBarText(text: "BEANS"),
        actions: [
          AppBarButton(
            onTap: () {
              showCustomModalSheet(
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
                    padding: const EdgeInsets.all(20),
                    itemCount: coffeeBeanProvider.coffeeBeans.length,
                    itemBuilder: (_, int index) {
                      return BeansContainer(
                        formKey: _formKey,
                        beanData: coffeeBeanProvider.coffeeBeans[index],
                      );
                    },
                    separatorBuilder: (_, __) {
                      return const Divider(
                        color: Color(0x00000000),
                        height: 20,
                      );
                    },
                  );
                },
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}

// template for the modal bottom sheet when editing or adding bean entries
// if beanName and description are input, they are set as the initial value in the text field
void showCustomModalSheet({
  required BuildContext context,
  required GlobalKey<FormBuilderState> formKey,
  required Function() submitAction,
  Function()? deleteAction,
  String? beanName,
  String? description,
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
      );
    },
  );
}
