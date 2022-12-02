import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/models/recipe_settings.dart';
import 'package:aeroquest/providers/recipes_provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class CoffeeBeanDropdown extends StatefulWidget {
  /// Defines the widget used for selecting a coffee bean for a recipe setting
  const CoffeeBeanDropdown({
    Key? key,
    this.recipeSettingsData,
  }) : super(key: key);

  /// Recipe settings data being passed
  final RecipeSettings? recipeSettingsData;

  @override
  State<CoffeeBeanDropdown> createState() => _CoffeeBeanDropdownState();
}

class _CoffeeBeanDropdownState extends State<CoffeeBeanDropdown> {
  /// Handles validate error text for the coffee bean dropdown menu
  bool showValidateErrorText = false;
  late final RecipesProvider _recipesProvider =
      Provider.of<RecipesProvider>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButtonHideUnderline(
          child: FormBuilder(
            key: Provider.of<RecipesProvider>(context, listen: false)
                .settingsBeanFormKey,
            child: DropdownButtonFormField2(
              items: List.generate(
                _recipesProvider.coffeeBeans.length,
                (index) {
                  int key = _recipesProvider.coffeeBeans.keys.elementAt(index);
                  return DropdownMenuItem(
                    child: Text(
                      _recipesProvider.coffeeBeans[key]!.beanName,
                      style: const TextStyle(
                        color: kPrimary,
                        fontSize: 16,
                      ),
                    ),
                    value: _recipesProvider.coffeeBeans[key]!.beanName,
                  );
                },
              ),
              value: (widget.recipeSettingsData != null)
                  ? _recipesProvider
                      .coffeeBeans[widget.recipeSettingsData!.beanId]!.beanName
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
                "Select coffee beans",
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
                      "Please select coffee beans",
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
