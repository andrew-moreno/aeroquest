import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import 'package:aeroquest/providers/recipes_provider.dart';
import 'package:aeroquest/screens/recipe_details/recipe_details_body/body_widgets/bean_settings_group_widgets/settings_value_slider.dart';
import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/widgets/animated_toggle.dart';
import 'package:aeroquest/widgets/custom_button.dart';
import 'package:aeroquest/models/recipe_settings.dart';
import 'package:aeroquest/models/recipe.dart';

class CustomSettingsModalSheet extends StatefulWidget {
  const CustomSettingsModalSheet({
    Key? key,
    required this.submitAction,
    this.deleteAction,
    this.recipeSettingsData,
    this.recipeData,
  }) : super(key: key);

  final Function() submitAction;
  final Function()? deleteAction;
  final RecipeSettings? recipeSettingsData;

  /// used to pass information about the recipe that the settings belong to
  /// used for determining whether hiding is not possible
  final Recipe? recipeData;

  @override
  State<CustomSettingsModalSheet> createState() =>
      _CustomSettingsModalSheetState();
}

class _CustomSettingsModalSheetState extends State<CustomSettingsModalSheet> {
  final List<String> _animatedToggleValues = const ["Show", "Hide"];

  @override
  void initState() {
    super.initState();
    Provider.of<RecipesProvider>(context, listen: false).tempSettingVisibility =
        (widget.recipeSettingsData?.visibility == null)
            ? SettingVisibility.shown
            : RecipeSettings.stringToSettingVisibility(
                widget.recipeSettingsData!.visibility);
    Provider.of<RecipesProvider>(context, listen: false).tempBeanId =
        widget.recipeSettingsData?.beanId;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedToggle(
                values: _animatedToggleValues,
                onToggleCallback: (index) {
                  index == 0
                      ? Provider.of<RecipesProvider>(context, listen: false)
                          .tempSettingVisibility = SettingVisibility.shown
                      : Provider.of<RecipesProvider>(context, listen: false)
                          .tempSettingVisibility = SettingVisibility.hidden;
                  log(Provider.of<RecipesProvider>(context, listen: false)
                      .tempSettingVisibility
                      .toString());
                },
                initialPosition:
                    (Provider.of<RecipesProvider>(context, listen: false)
                                .tempSettingVisibility ==
                            SettingVisibility.shown)
                        ? Position.left
                        : Position.right,
              ),
              const Divider(height: 20, color: Color(0x00000000)),
              DropdownButtonHideUnderline(
                child: Consumer<RecipesProvider>(
                  builder: (_, recipesProvider, ___) {
                    return FormBuilder(
                      key: recipesProvider.settingsBeanFormKey,
                      child: DropdownButtonFormField2(
                        items: List.generate(
                          recipesProvider.coffeeBeans.length,
                          (index) => DropdownMenuItem(
                            child: Text(
                              recipesProvider.coffeeBeans[index].beanName,
                              style: const TextStyle(
                                color: kPrimary,
                                fontSize: 16,
                              ),
                            ),
                            value: recipesProvider.coffeeBeans[index].beanName,
                          ),
                        ),
                        value: (widget.recipeSettingsData != null)
                            ? recipesProvider.coffeeBeans
                                .firstWhere((coffeeBean) =>
                                    coffeeBean.id ==
                                    widget.recipeSettingsData!.beanId)
                                .beanName
                            : null,
                        onChanged: (String? value) {
                          recipesProvider.tempBeanId = recipesProvider
                              .coffeeBeans
                              .firstWhere(
                                  (coffeeBean) => coffeeBean.beanName == value)
                              .id;
                        },
                        decoration: const InputDecoration(
                          hintText: "Select a bean",
                        ),
                        dropdownDecoration: const BoxDecoration(
                          borderRadius:
                              BorderRadius.all(Radius.circular(kCornerRadius)),
                          color: kLightSecondary,
                        ),
                        buttonWidth: double.infinity,
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: kPrimary,
                        ),
                        validator: (value) {
                          if (value == null) {
                            return "Please select a bean";
                          }
                          return null;
                        },
                      ),
                    );
                  },
                ),
              ),
              const Divider(height: 20, color: Color(0x00000000)),
              SettingsValueSlider(
                maxWidth: constraints.maxWidth,
                recipeSettingsData: widget.recipeSettingsData,
              ),
              const Divider(height: 20, color: Color(0x00000000)),
              Row(
                mainAxisAlignment: (widget.deleteAction != null)
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.center,
                children: [
                  CustomButton(
                    //TODO: fix button so not submitted when invalid bean
                    onTap: () {
                      if (!Provider.of<RecipesProvider>(context, listen: false)
                          .settingsBeanFormKey
                          .currentState!
                          .validate()) {
                        return;
                      } else {
                        log("hellp");
                        widget.submitAction();
                      }
                    },
                    buttonType: ButtonType.positive,
                    text: "Save",
                    width: constraints.maxWidth / 2 - 10,
                  ),
                  (widget.deleteAction != null)
                      ? CustomButton(
                          onTap: widget.deleteAction!,
                          buttonType: ButtonType.negative,
                          text: "Delete",
                          width: constraints.maxWidth / 2 - 10,
                        )
                      : Container(),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
