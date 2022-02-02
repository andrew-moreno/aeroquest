import 'package:aeroquest/widgets/card_header/card_header.dart';
import 'package:aeroquest/widgets/appbar/appbar_addButton.dart';
import 'package:aeroquest/widgets/appbar/appbar_leading.dart';
import 'package:aeroquest/widgets/appbar/appbar_text.dart';
import 'package:aeroquest/widgets/card_header/card_header_buttons.dart';
import 'package:aeroquest/widgets/custom_drawer.dart';
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

enum ModalAction {
  add,
  edit,
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
            backgroundColor: kBackgroundColor,
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
      builder: (builderContext, constraints) => Container(
        padding: const EdgeInsets.symmetric(
          vertical: 7,
          horizontal: 15,
        ),
        decoration: BoxDecoration(
          color: kLightNavy,
          borderRadius: BorderRadius.circular(10),
        ),
        child: CardHeader(
          title: beanName,
          description: description,
          actions: [
            CardHeaderButton(
              icon: Icons.edit,
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
                  beanName: beanName,
                  description: description,
                );
              },
            ),
            CardHeaderButton(
              icon: Icons.delete,
              onTap: () {
                Provider.of<BeansProvider>(builderContext, listen: false)
                    .deleteBean(index);
              },
            ),
          ],
        ),
      ),
    );
  }

  // template for the modal bottom sheet when editing or adding bean entries
  // if beanName and description are input, they are set as the initial value in the text field
  void _showCustomModalSheet({
    required dynamic submitAction,
    String? beanName,
    String? description,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(kCornerRadius)),
      ),
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildFormField(
                    formName: "beanName",
                    hint: "Name",
                    autoFocus: true,
                    validate: true,
                    initialValue: beanName),
                const Divider(height: 20, color: Color(0x00000000)),
                _buildFormField(
                    formName: "description",
                    hint: "Description",
                    autoFocus: false,
                    validate: false,
                    initialValue: description),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () {
                      submitAction();
                    },
                    icon: const Icon(
                      Icons.send,
                      color: kAccentYellow,
                      size: 25,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // template for the text field
  FormBuilderTextField _buildFormField({
    required String formName,
    required String hint, // hint to display in the text field
    required bool autoFocus, // autofocus on Name field
    required bool validate, // description doesn't require validation
    String? initialValue,
  }) {
    return FormBuilderTextField(
      cursorColor: kTextColor,
      cursorWidth: 1,
      name: formName,
      initialValue: initialValue,
      style: const TextStyle(color: kTextColor, fontSize: 16),
      autofocus: autoFocus,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        hintText: hint,
        hintStyle: const TextStyle(
          color: kTextColor,
          fontFamily: "Poppins",
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kCornerRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kCornerRadius),
          borderSide: const BorderSide(color: kAccentOrange),
        ),
        filled: true,
        fillColor: kLightNavy,
      ),
      validator: (value) {
        if (validate && (value == null || value.isEmpty)) {
          return "Please enter a name for these beans";
        }
      },
    );
  }
}
