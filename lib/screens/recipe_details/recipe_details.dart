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
    Future<void> _showDiscardChangesPopup(bool isOsBackPressed) async {
      // os back refers to operating system back button
      // as opposed to back button in app
      return await showDialog(
        context: context,
        builder: (context) => ExitDialog(
          titleText: "Discard changes?",
          leftAction: () => Navigator.of(context).pop(false),
          rightAction: () {
            Provider.of<RecipesProvider>(context, listen: false)
                .changeEditMode();
            Provider.of<RecipesProvider>(context, listen: false)
                .setTempRecipe(recipeData.id!);
            Provider.of<RecipesProvider>(context, listen: false)
                .setTempRecipeSettings(recipeData.id!);
            Navigator.of(context).pop(true);
            if (!isOsBackPressed) {
              Navigator.of(context).pop(true);
            }
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

    bool _isRecipeChanged() {
      return Provider.of<RecipesProvider>(context, listen: false)
          .isRecipeChanged(
              originalTitle: recipeData.title,
              originalDescription: recipeData.description,
              originalPushPressure:
                  Recipe.stringToPushPressure(recipeData.pushPressure),
              originalBrewMethod:
                  Recipe.stringToBrewMethod(recipeData.brewMethod),
              recipeId: recipeData.id!);
    }

    // same as exitDetailsPage - all edits should be in both
    Future<bool> _onWillPop() async {
      if (Provider.of<RecipesProvider>(context, listen: false).editMode ==
          EditMode.enabled) {
        if (_isRecipeChanged()) {
          _showDiscardChangesPopup(true);
        } else {
          Provider.of<RecipesProvider>(context, listen: false).changeEditMode();
          Provider.of<RecipesProvider>(context, listen: false)
              .clearTempRecipeSettings();
          return Future.value(false);
        }
      }
      Provider.of<RecipesProvider>(context, listen: false)
          .clearTempRecipeSettings();
      return Future.value(true);
    }

    // same as _onWillPop - all edits should be in both
    void _exitDetailsPage() {
      if (Provider.of<RecipesProvider>(context, listen: false).editMode ==
          EditMode.enabled) {
        if (_isRecipeChanged()) {
          _showDiscardChangesPopup(false);
        } else {
          Provider.of<RecipesProvider>(context, listen: false).changeEditMode();
          Provider.of<RecipesProvider>(context, listen: false)
              .clearTempRecipeSettings();
          Navigator.of(context).pop();
        }
      } else {
        Provider.of<RecipesProvider>(context, listen: false)
            .clearTempRecipeSettings();
        Navigator.of(context).pop();
      }
    }

    // how tf do i make this work

    // Tuple2<Future<bool> Function()?, void> _onWillPop2() {
    //   if (Provider.of<RecipesProvider>(context, listen: false).editMode ==
    //       EditMode.enabled) {
    //     if (_isRecipeChanged()) {
    //       _showDiscardChangesPopup();
    //     } else {
    //       Provider.of<RecipesProvider>(context, listen: false).changeEditMode();
    //       Provider.of<RecipesProvider>(context, listen: false)
    //           .clearTempRecipeSettings();
    //       return Tuple2<Future<bool> Function()?, void>(
    //           () => Future.value(false), Navigator.of(context).pop());
    //     }
    //   }
    //   Provider.of<RecipesProvider>(context, listen: false)
    //       .clearTempRecipeSettings();
    //   return Tuple2<Future<bool> Function()?, void>(
    //       () => Future.value(true), Navigator.of(context).pop());
    // }

    void _saveRecipe() {
      // exiting edit mode
      // checks if any changes made before showing popup
      if (!Provider.of<RecipesProvider>(context, listen: false)
          .recipePropertiesFormKey
          .currentState!
          .validate()) {
        return;
      }
      if (Provider.of<RecipesProvider>(context, listen: false).editMode ==
          EditMode.enabled) {
        Provider.of<RecipesProvider>(context, listen: false).saveRecipe();
        Provider.of<RecipesProvider>(context, listen: false).changeEditMode();
      } else {
        // entering edit mode
        Provider.of<RecipesProvider>(context, listen: false).changeEditMode();
      }
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
                      _exitDetailsPage();
                    },
                  ),
                  actions: [
                    AppBarButton(
                      onTap: () {
                        _saveRecipe();
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
                        recipeId: recipeData.id!,
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
