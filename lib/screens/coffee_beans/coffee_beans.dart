import 'package:aeroquest/widgets/card_header.dart';
import 'package:aeroquest/widgets/appbar/appbar_addButton.dart';
import 'package:aeroquest/widgets/appbar/appbar_leading.dart';
import 'package:aeroquest/widgets/appbar/appbar_text.dart';
import 'package:aeroquest/widgets/custom_drawer.dart';
import 'package:aeroquest/widgets/modal_button.dart';
import 'package:aeroquest/screens/coffee_beans/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../../models/beans_provider.dart';
import '../../constraints.dart';

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
    return ChangeNotifierProvider(
      create: (_) => BeansProvider(),
      builder: (builderContext, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: kPrimary,
            elevation: 0,
            centerTitle: true,
            leading: const AppBarLeading(function: LeadingFunction.menu),
            title: const AppBarText(text: "BEANS"),
            actions: [
              AppBarAddButton(
                onTap: () {
                  _showCustomModalSheet(
                    submitAction: () {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                      String beanName =
                          _formKey.currentState!.fields["beanName"]!.value;
                      String? description =
                          _formKey.currentState!.fields["description"]?.value;
                      Provider.of<BeansProvider>(builderContext, listen: false)
                          .addBean(beanName, description);
                      Navigator.of(context).pop();
                    },
                  );
                },
                icon: Icons.add,
              ),
            ],
          ),
          drawer: const CustomDrawer(),
          body: SafeArea(
            child: Consumer<BeansProvider>(
              builder: (context, data, child) => ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                itemCount: data.beans.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildBeansContainer(
                    data.beans[index].beanName,
                    data.beans[index].description,
                    index,
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    color: Color(0x00000000),
                    height: 20,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  // template for the each coffee bean entry
  // layout builder required for provider use
  LayoutBuilder _buildBeansContainer(beanName, description, index) {
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
            title: beanName,
            description: description,
          ),
        ),
        onTap: () {
          _showCustomModalSheet(
            submitAction: () {
              if (!_formKey.currentState!.validate()) {
                return;
              }
              String beanName =
                  _formKey.currentState!.fields["beanName"]!.value;
              String? description =
                  _formKey.currentState!.fields["description"]?.value;
              Provider.of<BeansProvider>(builderContext, listen: false)
                  .editBean(beanName, description, index);
              Navigator.of(context).pop();
            },
            deleteAction: () {
              Provider.of<BeansProvider>(builderContext, listen: false)
                  .deleteBean(index!);
              Navigator.of(context).pop();
            },
            beanName: beanName,
            description: description,
            index: index,
          );
        },
      ),
    );
  }

  // template for the modal bottom sheet when editing or adding bean entries
  // if beanName and description are input, they are set as the initial value in the text field
  void _showCustomModalSheet({
    required dynamic submitAction,
    dynamic deleteAction,
    String? beanName,
    String? description,
    int? index,
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
                              onTap: deleteAction,
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
      },
    );
  }
}
