import 'package:aeroquest/providers/variables_slider_provider.dart';
import 'package:aeroquest/screens/recipe_details/recipe_details.dart';
import 'package:aeroquest/widgets/add_to_recipe_button.dart';
import 'package:aeroquest/widgets/custom_modal_sheet/value_slider_group_template.dart';
import 'package:aeroquest/widgets/empty_details_text.dart';
import 'package:provider/provider.dart';
import 'dart:core';

import 'package:flutter/material.dart';

import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/models/recipe_variables.dart';
import 'package:aeroquest/providers/recipes_provider.dart';
import 'package:aeroquest/widgets/recipe_variables/widgets/bean_variables.dart';

class BeanVariablesGroup extends StatefulWidget {
  /// Defines the widget for displaying all recipe variables on the recipe
  /// details page
  const BeanVariablesGroup({
    Key? key,
    required this.recipeEntryId,
  }) : super(key: key);

  /// Recipe that these recipe variables are associated with
  final int recipeEntryId;

  @override
  State<BeanVariablesGroup> createState() => _BeanVariablesGroupState();
}

class _BeanVariablesGroupState extends State<BeanVariablesGroup> {
  late final _recipesProvider =
      Provider.of<RecipesProvider>(context, listen: false);

  Map<int, RecipeVariables> selectRecipeVariablesData() {
    if (_recipesProvider.editMode == EditMode.enabled) {
      return _recipesProvider.tempRecipeVariables;
    } else {
      return _recipesProvider.recipeVariables[widget.recipeEntryId] ?? {};
    }
  }

  /// If no coffee beans have been added, displays a snackbar that notifies the
  /// user and lets them add a coffee bean from the RecipeDetails page.
  /// Otherwise, opens the modal sheet for adding recipe variables
  // void selectAddVariablesMode() {
  //   if (_recipesProvider.coffeeBeans.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: const Text(
  //           "Add a coffee bean first!",
  //           style: TextStyle(
  //             fontFamily: "Poppins",
  //             fontWeight: FontWeight.w500,
  //             color: kPrimary,
  //           ),
  //         ),
  //         backgroundColor: kLightSecondary,
  //         elevation: 10,
  //         action: SnackBarAction(
  //           label: "Add",
  //           textColor: kAccent,
  //           onPressed: () {
  //             showCustomCoffeeBeanModalSheet(
  //               submitAction: () async {
  //                 if (!_formKey.currentState!.validate()) {
  //                   return;
  //                 }
  //                 String beanName =
  //                     _formKey.currentState!.fields["beanName"]!.value;
  //                 String? description =
  //                     _formKey.currentState!.fields["description"]?.value;
  //                 _recipesProvider.addBean(beanName, description);
  //                 Navigator.of(context).pop();
  //                 showAddModal();
  //               },
  //               autoFocusTitleField: true,
  //               context: context,
  //               formKey: _formKey,
  //             );
  //           },
  //         ),
  //       ),
  //     );
  //   } else {
  //     showAddModal();
  //   }
  // }

  /// Displays the modal sheet for adding recipe variables
  void showAddModal({RecipeVariables? recipeVariablesData}) {
    showCustomModalSheet(
      modalType: ModalType.variables,
      submitAction: () {
        if (!_recipesProvider.variablesBeanFormKey.currentState!.validate()) {
          return;
        }
        setRecipesProviderTempVariablesParameters();
        _recipesProvider.tempAddVariable(
            widget.recipeEntryId); // index doesn't matter for recipe entry id
        Navigator.of(context).pop();
      },
      recipeVariablesData: recipeVariablesData,
      context: context,
    );
  }

  /// Displays the modal sheet for editing recipe variables
  void showEditingModal(int recipeVariablesId) {
    showCustomModalSheet(
      modalType: ModalType.variables,
      submitAction: () {
        setRecipesProviderTempVariablesParameters();
        _recipesProvider.editVariables(
            _recipesProvider.tempRecipeVariables[recipeVariablesId]!);
        Navigator.of(context).pop();
      },
      deleteAction: () {
        _recipesProvider.tempDeleteVariables(recipeVariablesId);
        Navigator.of(context).pop();
      },
      recipeVariablesData:
          _recipesProvider.tempRecipeVariables[recipeVariablesId],
      context: context,
    );
  }

  /// Sets the temp recipe variables parameter from the VariablesSliderProvider
  /// to the associated temp recipe variables parameter in the RecipeProvider
  void setRecipesProviderTempVariablesParameters() {
    Provider.of<RecipesProvider>(context, listen: false).tempGrindSetting =
        Provider.of<VariablesSliderProvider>(context, listen: false)
            .tempGrindSetting;
    Provider.of<RecipesProvider>(context, listen: false).tempCoffeeAmount =
        Provider.of<VariablesSliderProvider>(context, listen: false)
            .tempCoffeeAmount;
    Provider.of<RecipesProvider>(context, listen: false).tempWaterAmount =
        Provider.of<VariablesSliderProvider>(context, listen: false)
            .tempWaterAmount;
    Provider.of<RecipesProvider>(context, listen: false).tempWaterTemp =
        Provider.of<VariablesSliderProvider>(context, listen: false)
            .tempWaterTemp;
    Provider.of<RecipesProvider>(context, listen: false).tempBrewTime =
        Provider.of<VariablesSliderProvider>(context, listen: false)
            .tempBrewTime;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipesProvider>(
      builder: (_, recipesProvider, __) {
        Map<int, RecipeVariables> recipeVariablesData =
            selectRecipeVariablesData();
        return Column(
          children: [
            (recipeVariablesData.isNotEmpty)
                ? ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: recipeVariablesData.length,
                    shrinkWrap: true,
                    itemBuilder: (context, int index) {
                      int id = recipeVariablesData.keys
                          .elementAt(recipeVariablesData.length - index - 1);

                      return GestureDetector(
                        onTap: () {
                          if (_recipesProvider.editMode == EditMode.enabled) {
                            showEditingModal(id);
                          }
                        },
                        child: Visibility(
                          visible: (_recipesProvider.editMode ==
                                      EditMode.disabled &&
                                  RecipeVariables.stringToVariablesVisibility(
                                          recipeVariablesData[id]!
                                              .visibility) ==
                                      VariablesVisibility.hidden)
                              ? false
                              : true,
                          child: Opacity(
                            opacity: (_recipesProvider.editMode ==
                                        EditMode.enabled &&
                                    RecipeVariables.stringToVariablesVisibility(
                                            recipeVariablesData[id]!
                                                .visibility) ==
                                        VariablesVisibility.hidden)
                                ? 0.5
                                : 1,
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 5, right: 5, bottom: 5),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: kDarkSecondary,
                                borderRadius:
                                    BorderRadius.circular(kCornerRadius),
                                boxShadow: (_recipesProvider.editMode ==
                                        EditMode.enabled)
                                    ? [kVariablesBoxShadow]
                                    : [],
                              ),
                              child: BeanVariables(
                                recipeVariables: recipeVariablesData[id]!,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (_, index) {
                      return const SizedBox(height: 10);
                    },
                  )
                : const EmptyDetailsText(dataType: RecipeDetailsText.variable),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: (_recipesProvider.editMode == EditMode.enabled)
                  ? AddToRecipeButton(
                      buttonText: "Add Variable Set",
                      onTap: showAddModal,
                    )
                  : Container(),
            ),
          ],
        );
      },
    );
  }
}
