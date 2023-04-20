import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/models/recipe_variables.dart';
import 'package:aeroquest/providers/recipes_provider.dart';
import 'package:aeroquest/screens/coffee_beans/coffee_beans.dart';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class CoffeeBeanDropdown extends StatefulWidget {
  /// Defines the widget used for selecting a coffee bean for a recipe variable
  const CoffeeBeanDropdown({
    Key? key,
    this.recipeVariablesData,
  }) : super(key: key);

  /// Recipe variables data being passed
  final RecipeVariables? recipeVariablesData;

  @override
  State<CoffeeBeanDropdown> createState() => _CoffeeBeanDropdownState();
}

class _CoffeeBeanDropdownState extends State<CoffeeBeanDropdown> {
  /// Handles validate error text for the coffee bean dropdown menu
  bool showValidateErrorText = false;
  late final RecipesProvider _recipesProvider =
      Provider.of<RecipesProvider>(context, listen: false);

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  final GlobalKey<FormFieldState> _dropdownFormFieldKey =
      GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButtonHideUnderline(
          child: FormBuilder(
            key: Provider.of<RecipesProvider>(context, listen: false)
                .variablesBeanFormKey,
            child: DropdownButtonFormField2(
              key: _dropdownFormFieldKey,
              items: List.generate(
                    _recipesProvider.coffeeBeans.length,
                    (index) {
                      int key = _recipesProvider.coffeeBeans.keys.elementAt(
                          _recipesProvider.coffeeBeans.length - index - 1);
                      return DropdownMenuItem(
                        child: Text(
                          _recipesProvider.coffeeBeans[key]!.beanName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: kPrimary,
                            fontSize: 16,
                          ),
                        ),
                        value: _recipesProvider.coffeeBeans[key]!.beanName,
                      );
                    },
                  ) +
                  [
                    DropdownMenuItem(
                      enabled: false,
                      child: TextButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.all(0),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          showCustomCoffeeBeanModalSheet(
                            submitAction: () async {
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }
                              String beanName = _formKey
                                  .currentState!.fields["beanName"]!.value;
                              String? description = _formKey
                                  .currentState!.fields["description"]?.value;
                              await _recipesProvider.addBean(
                                  beanName, description);

                              Navigator.of(context).pop();
                              _dropdownFormFieldKey.currentState!
                                  .didChange(beanName);
                            },
                            autoFocusTitleField: true,
                            context: context,
                            formKey: _formKey,
                          );
                        },
                        child: const SizedBox(
                          width: double.infinity,
                          child: Text(
                            "Add Coffee Bean",
                            style: TextStyle(color: kAccent, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
              value: (widget.recipeVariablesData != null)
                  ? _recipesProvider
                      .coffeeBeans[widget.recipeVariablesData!.beanId]!.beanName
                  : null,
              onChanged: (String? value) {
                _recipesProvider.tempBeanId = _recipesProvider
                    .coffeeBeans.values
                    .firstWhere((coffeeBean) => coffeeBean.beanName == value)
                    .id;
                setState(() {
                  showValidateErrorText = false;
                });
              },
              hint: const Text(
                "Select a coffee bean",
                style: TextStyle(
                  color: kPrimary,
                  fontFamily: "Poppins",
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              buttonHeight: 45,
              isExpanded: true,
              buttonPadding: const EdgeInsets.symmetric(
                  horizontal: kInputDecorationHorizontalPadding),
              decoration: const InputDecoration(
                errorStyle: TextStyle(height: 0),
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              dropdownDecoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(kCornerRadius)),
                color: kLightSecondary,
              ),
              buttonWidth: double.infinity,
              icon: const Icon(
                Icons.arrow_drop_down,
                color: kPrimary,
              ),
              validator: (value) {
                if (value == null) {
                  setState(() {
                    showValidateErrorText = true;
                  });
                  return "";
                }

                return null;
              },
            ),
          ),
        ),
        (showValidateErrorText)
            ? Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                      left: kInputDecorationHorizontalPadding,
                      top: 5,
                    ),
                    child: Text(
                      "Please select a coffee bean",
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(color: kDeleteRed),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              )
            : const SizedBox(height: 20),
      ],
    );
  }
}
