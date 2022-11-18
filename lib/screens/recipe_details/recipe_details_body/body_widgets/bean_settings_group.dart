import 'package:aeroquest/models/coffee_bean.dart';
import 'package:aeroquest/providers/coffee_bean_provider.dart';
import 'package:aeroquest/screens/coffee_beans/coffee_beans.dart';
import 'package:aeroquest/screens/recipe_details/recipe_details_body/recipe_details_body.dart';
import 'package:aeroquest/widgets/add_to_recipe_button.dart';
import 'package:aeroquest/widgets/custom_modal_sheet/value_slider_group_template.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'dart:core';

import 'package:flutter/material.dart';

import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/models/recipe_settings.dart';
import 'package:aeroquest/providers/recipes_provider.dart';
import 'package:aeroquest/widgets/recipe_settings/widgets/bean_settings.dart';

class BeanSettingsGroup extends StatefulWidget {
  const BeanSettingsGroup({
    Key? key,
    required this.recipeEntryId,
  }) : super(key: key);

  final int recipeEntryId;

  @override
  State<BeanSettingsGroup> createState() => _BeanSettingsGroupState();
}

class _BeanSettingsGroupState extends State<BeanSettingsGroup> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipesProvider>(
      builder: (_, recipesProvider, ___) {
        return Column(
          children: [
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recipesProvider.tempRecipeSettings.length,
              shrinkWrap: true,
              itemBuilder: (context, int index) {
                int key =
                    recipesProvider.tempRecipeSettings.keys.elementAt(index);

                return GestureDetector(
                  onTap: () {
                    if (recipesProvider.editMode == EditMode.enabled) {
                      showCustomModalSheet(
                          modalType: ModalType.settings,
                          submitAction: () {
                            recipesProvider.editSetting(
                                recipesProvider.tempRecipeSettings[key]!, key);
                            Navigator.of(context).pop();
                          },
                          deleteAction: () {
                            recipesProvider.tempDeleteSetting(key);
                            Navigator.of(context).pop();
                          },
                          recipeSettingsData:
                              recipesProvider.tempRecipeSettings[key],
                          context: context);
                    }
                  },
                  child: Visibility(
                    visible: (recipesProvider.editMode == EditMode.disabled &&
                            RecipeSettings.stringToSettingVisibility(
                                    recipesProvider
                                        .tempRecipeSettings[key]!.visibility) ==
                                SettingVisibility.hidden)
                        ? false
                        : true,
                    child: Opacity(
                      opacity: (recipesProvider.editMode == EditMode.enabled &&
                              RecipeSettings.stringToSettingVisibility(
                                      recipesProvider.tempRecipeSettings[key]!
                                          .visibility) ==
                                  SettingVisibility.hidden)
                          ? 0.5
                          : 1,
                      child: Container(
                        padding:
                            const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: kDarkSecondary,
                          borderRadius: BorderRadius.circular(kCornerRadius),
                          boxShadow:
                              (recipesProvider.editMode == EditMode.enabled)
                                  ? [kSettingsBoxShadow]
                                  : [],
                        ),
                        child: BeanSettings(
                          recipeSetting:
                              recipesProvider.tempRecipeSettings[key]!,
                        ),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (_, index) {
                return const Divider(
                  color: Color(0x00000000),
                  height: 10,
                );
              },
            ),
            const Divider(
              color: Color(0x00000000),
              height: 20,
            ),
            (recipesProvider.editMode == EditMode.enabled)
                ? AddToRecipeButton(
                    buttonText: "Add Setting",
                    onTap: () {
                      if (recipesProvider.coffeeBeans.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              "Add a coffee bean first!",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500,
                                color: kPrimary,
                              ),
                            ),
                            backgroundColor: kLightSecondary,
                            elevation: 10,
                            action: SnackBarAction(
                                label: "Add",
                                textColor: kAccent,
                                onPressed: () {
                                  showCustomCoffeeBeanModalSheet(
                                    submitAction: () async {
                                      if (!_formKey.currentState!.validate()) {
                                        return;
                                      }
                                      String beanName = _formKey.currentState!
                                          .fields["beanName"]!.value;
                                      String? description = _formKey
                                          .currentState!
                                          .fields["description"]
                                          ?.value;
                                      CoffeeBean newCoffeeBean =
                                          await Provider.of<CoffeeBeanProvider>(
                                                  context,
                                                  listen: false)
                                              .addBean(beanName, description);
                                      recipesProvider.addBean(newCoffeeBean);
                                      Navigator.of(context).pop();
                                    },
                                    context: context,
                                    formKey: _formKey,
                                  );
                                }),
                          ),
                        );
                      } else {
                        showCustomModalSheet(
                            modalType: ModalType.settings,
                            submitAction: () {
                              if (!Provider.of<RecipesProvider>(context,
                                      listen: false)
                                  .settingsBeanFormKey
                                  .currentState!
                                  .validate()) {
                                return;
                              }
                              recipesProvider.tempAddSetting(widget
                                  .recipeEntryId); // index doesn't matter for recipe entry id
                              Navigator.of(context).pop();
                            },
                            context: context);
                      }
                    },
                  )
                : Container(),
          ],
        );
      },
    );
  }
}
