import 'package:aeroquest/providers/settings_slider_provider.dart';
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
  /// Defines the widget for displaying all recipe settings on the recipe
  /// details page
  const BeanSettingsGroup({
    Key? key,
    required this.recipeEntryId,
  }) : super(key: key);

  /// Recipe that these recipe settings are associated with
  final int recipeEntryId;

  @override
  State<BeanSettingsGroup> createState() => _BeanSettingsGroupState();
}

class _BeanSettingsGroupState extends State<BeanSettingsGroup> {
  /// Form key used for validation in the modal sheet
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  late final _recipesProvider =
      Provider.of<RecipesProvider>(context, listen: false);

  Map<int, RecipeSettings> selectRecipeSettingsData() {
    if (_recipesProvider.editMode == EditMode.enabled) {
      return _recipesProvider.tempRecipeSettings;
    } else {
      return _recipesProvider.recipeSettings[widget.recipeEntryId] ?? {};
    }
  }

  /// If no coffee beans have been added, displays a snackbar that notifies the
  /// user and lets them add a coffee bean from the RecipeDetails page.
  /// Otherwise, opens the modal sheet for adding recipe settings
  void selectAddSettingMode() {
    if (_recipesProvider.coffeeBeans.isEmpty) {
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
                  String beanName =
                      _formKey.currentState!.fields["beanName"]!.value;
                  String? description =
                      _formKey.currentState!.fields["description"]?.value;

                  _recipesProvider.addBean(
                    beanName,
                    description,
                  );
                  Navigator.of(context).pop();
                },
                autoFocusTitleField: true,
                context: context,
                formKey: _formKey,
              );
            },
          ),
        ),
      );
    } else {
      showCustomModalSheet(
        modalType: ModalType.settings,
        submitAction: () {
          if (!_recipesProvider.settingsBeanFormKey.currentState!.validate()) {
            return;
          }
          setRecipesProviderTempSettingParameters();
          _recipesProvider.tempAddSetting(
              widget.recipeEntryId); // index doesn't matter for recipe entry id
          Navigator.of(context).pop();
        },
        context: context,
      );
    }
  }

  /// Displays the modal sheet for editing recipe settings
  void showEditingModal(int recipeSettingId) {
    showCustomModalSheet(
      modalType: ModalType.settings,
      submitAction: () {
        setRecipesProviderTempSettingParameters();
        _recipesProvider
            .editSetting(_recipesProvider.tempRecipeSettings[recipeSettingId]!);
        Navigator.of(context).pop();
      },
      deleteAction: () {
        _recipesProvider.tempDeleteSetting(recipeSettingId);
        Navigator.of(context).pop();
      },
      recipeSettingsData: _recipesProvider.tempRecipeSettings[recipeSettingId],
      context: context,
    );
  }

  /// Sets the temp recipe settings parameter from the SettingsSliderProvider
  /// to the associated temp recipe settings parameter in the RecipeProvider
  void setRecipesProviderTempSettingParameters() {
    Provider.of<RecipesProvider>(context, listen: false).tempGrindSetting =
        Provider.of<SettingsSliderProvider>(context, listen: false)
            .tempGrindSetting;
    Provider.of<RecipesProvider>(context, listen: false).tempCoffeeAmount =
        Provider.of<SettingsSliderProvider>(context, listen: false)
            .tempCoffeeAmount;
    Provider.of<RecipesProvider>(context, listen: false).tempWaterAmount =
        Provider.of<SettingsSliderProvider>(context, listen: false)
            .tempWaterAmount;
    Provider.of<RecipesProvider>(context, listen: false).tempWaterTemp =
        Provider.of<SettingsSliderProvider>(context, listen: false)
            .tempWaterTemp;
    Provider.of<RecipesProvider>(context, listen: false).tempBrewTime =
        Provider.of<SettingsSliderProvider>(context, listen: false)
            .tempBrewTime;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipesProvider>(
      builder: (_, recipesProvider, __) {
        Map<int, RecipeSettings> recipeSettingsData =
            selectRecipeSettingsData();
        return Column(
          children: [
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recipeSettingsData.length,
              shrinkWrap: true,
              itemBuilder: (context, int index) {
                int id = recipeSettingsData.keys
                    .elementAt(recipeSettingsData.length - index - 1);

                return GestureDetector(
                  onTap: () {
                    if (_recipesProvider.editMode == EditMode.enabled) {
                      showEditingModal(id);
                    }
                  },
                  child: Visibility(
                    visible: (_recipesProvider.editMode == EditMode.disabled &&
                            RecipeSettings.stringToSettingVisibility(
                                    recipeSettingsData[id]!.visibility) ==
                                SettingVisibility.hidden)
                        ? false
                        : true,
                    child: Opacity(
                      opacity: (_recipesProvider.editMode == EditMode.enabled &&
                              RecipeSettings.stringToSettingVisibility(
                                      recipeSettingsData[id]!.visibility) ==
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
                              (_recipesProvider.editMode == EditMode.enabled)
                                  ? [kSettingsBoxShadow]
                                  : [],
                        ),
                        child: BeanSettings(
                          recipeSetting: recipeSettingsData[id]!,
                        ),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (_, index) {
                return const SizedBox(height: 10);
              },
            ),
            const SizedBox(height: 20),
            (_recipesProvider.editMode == EditMode.enabled)
                ? AddToRecipeButton(
                    buttonText: "Add Setting",
                    onTap: selectAddSettingMode,
                  )
                : Container(),
          ],
        );
      },
    );
  }
}
