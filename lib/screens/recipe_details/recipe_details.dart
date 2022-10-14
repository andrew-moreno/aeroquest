import 'package:aeroquest/widgets/appbar/appbar_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:aeroquest/providers/recipes_provider.dart';
import 'package:aeroquest/screens/recipe_details/recipe_details_body/recipe_details_body.dart';
import 'package:aeroquest/screens/recipe_details/recipe_details_header.dart';
import 'package:aeroquest/widgets/appbar/appbar_leading.dart';
import 'package:aeroquest/widgets/exit_dialog.dart';
import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/models/recipe.dart';

class RecipeDetails extends StatelessWidget {
  RecipeDetails({
    Key? key,
    required this.recipeData,
    required this.showDeleteButton,
  }) : super(key: key);

  final Recipe recipeData;
  final bool showDeleteButton;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    Future<bool> _showDiscardChangesPopup() async {
      return await showDialog(
        context: context,
        builder: (context) => ExitDialog(
          titleText: "Discard changes?",
          leftAction: () => Navigator.of(context).pop(false),
          rightAction: () {
            Provider.of<RecipesProvider>(context, listen: false)
                .changeEditMode();
            Provider.of<RecipesProvider>(context, listen: false)
                .recipePropertiesFormKey
                .currentState!
                .reset();
            Provider.of<RecipesProvider>(context, listen: false)
                .setTempRecipeSettings(recipeData.id!);
            Navigator.of(context).pop(true);
            Navigator.of(context).pop(true);
          },
        ),
      );
    }

    Future<bool> _showConfirmDeletePopup() async {
      return await showDialog(
        context: context,
        builder: (context) => ExitDialog(
          titleText: "Confirm delete",
          leftAction: () {
            Navigator.of(context).pop(false);
          },
          rightAction: () {
            Provider.of<RecipesProvider>(context, listen: false)
                .deleteRecipe(recipeData.id!);
            Navigator.of(context).pop(false);
            Navigator.of(context).pop(false);
            if (Provider.of<RecipesProvider>(context, listen: false).editMode ==
                EditMode.enabled) {
              Provider.of<RecipesProvider>(context, listen: false)
                  .changeEditMode();
            }
          },
          leftText: "Cancel",
          rightText: "Delete",
        ),
      );
    }

    Future<bool> _onWillPop() async {
      if (Provider.of<RecipesProvider>(context, listen: false).editMode ==
          EditMode.enabled) {
        if (Provider.of<RecipesProvider>(context, listen: false)
            .isRecipeChanged(
                originalTitle: recipeData.title,
                originalDescription: recipeData.description,
                recipeId: recipeData.id!)) {
          _showDiscardChangesPopup();
        } else {
          Provider.of<RecipesProvider>(context, listen: false).changeEditMode();
          return Future.value(false);
        }
      }
      return Future.value(true);
    }

    return Scaffold(
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: SafeArea(
          child: StretchingOverscrollIndicator(
            axisDirection: AxisDirection.down,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  backgroundColor: kPrimary,
                  leading: AppBarLeading(
                    function: LeadingFunction.back,
                    onPressed: () {
                      if (Provider.of<RecipesProvider>(context, listen: false)
                              .editMode ==
                          EditMode.enabled) {
                        if (Provider.of<RecipesProvider>(context, listen: false)
                            .isRecipeChanged(
                                originalTitle: recipeData.title,
                                originalDescription: recipeData.description,
                                recipeId: recipeData.id!)) {
                          _showDiscardChangesPopup();
                        } else {
                          Provider.of<RecipesProvider>(context, listen: false)
                              .changeEditMode();
                          Provider.of<RecipesProvider>(context, listen: false)
                              .clearTempRecipeSettings();
                          Navigator.of(context).pop();
                        }
                      } else {
                        Provider.of<RecipesProvider>(context, listen: false)
                            .clearTempRecipeSettings();
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  actions: [
                    AppBarButton(
                      onTap: () {
                        // exiting edit mode
                        // checks if any changes made before showing popup
                        if (!Provider.of<RecipesProvider>(context,
                                listen: false)
                            .recipePropertiesFormKey
                            .currentState!
                            .validate()) {
                          return;
                        }
                        if (Provider.of<RecipesProvider>(context, listen: false)
                                .editMode ==
                            EditMode.enabled) {
                          Recipe updatedRecipe = recipeData.copy(
                              title: Provider.of<RecipesProvider>(context,
                                      listen: false)
                                  .recipePropertiesFormKey
                                  .currentState!
                                  .fields["recipeTitle"]!
                                  .value,
                              description: Provider.of<RecipesProvider>(context,
                                      listen: false)
                                  .recipePropertiesFormKey
                                  .currentState!
                                  .fields["recipeDescription"]
                                  ?.value);
                          Provider.of<RecipesProvider>(context, listen: false)
                              .saveRecipe(updatedRecipe);
                          Provider.of<RecipesProvider>(context, listen: false)
                              .changeEditMode();
                        } else {
                          // entering edit mode
                          Provider.of<RecipesProvider>(context, listen: false)
                              .changeEditMode();
                        }
                      },
                      icon: (Provider.of<RecipesProvider>(context).editMode ==
                              EditMode.enabled)
                          ? Icons.check
                          : Icons.edit,
                    ),
                    (showDeleteButton)
                        ? AppBarButton(
                            onTap: () {
                              _showConfirmDeletePopup();
                            },
                            icon: Icons.delete,
                          )
                        : Container(),
                  ],
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      const Divider(
                        height: 5,
                        color: Color(0x00000000),
                      ),
                      Consumer<RecipesProvider>(
                        builder: (_, recipesProvider, ___) {
                          return RecipeDetailsHeader(
                            titleValue: recipesProvider.recipes
                                .firstWhere(
                                  (recipe) => recipe.id == recipeData.id,
                                  orElse: () => recipeData,
                                )
                                .title,
                            descriptionValue: recipesProvider.recipes
                                    .firstWhere(
                                      (recipe) => recipe.id == recipeData.id,
                                      orElse: () => recipeData,
                                    )
                                    .description ??
                                "",
                          );
                        },
                      ),
                      const Divider(
                        height: 20,
                        color: Color(0x00000000),
                      ),
                      RecipeDetailsBody(
                        recipeData: recipeData,
                      ),
                    ],
                  ),
                ),
                // fills remaining space if content doesn't expand to height of screen
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: kDarkSecondary,
                      // necessary to fix 1 pixel gap bug in slivers
                      boxShadow: [
                        BoxShadow(
                          color: kDarkSecondary,
                          blurRadius: 0.0,
                          spreadRadius: 0.0,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
