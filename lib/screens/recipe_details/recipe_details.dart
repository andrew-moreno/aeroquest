import 'package:aeroquest/databases/recipe_settings_database.dart';
import 'package:aeroquest/widgets/appbar/appbar_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:aeroquest/providers/recipes_provider.dart';
import 'package:aeroquest/screens/recipe_details/recipe_details_body/recipe_details_body.dart';
import 'package:aeroquest/screens/recipe_details/recipe_details_header.dart';
import 'package:aeroquest/widgets/appbar/appbar_leading.dart';
import 'package:aeroquest/widgets/exit_dialog.dart';
import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/models/recipe_settings.dart';
import 'package:aeroquest/models/recipe.dart';

class RecipeDetails extends StatelessWidget {
  RecipeDetails({
    Key? key,
    required this.recipeData,
    required this.recipeSettingsData,
  }) : super(key: key);

  final Recipe recipeData;
  final List<RecipeSettings> recipeSettingsData;
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
                .formKey
                .currentState!
                .reset();
            Navigator.of(context).pop(true);
          },
        ),
      );
    }

    // Future<bool> _showConfirmSavePopup() async {
    //   return await showDialog(
    //     context: context,
    //     builder: (context) => ExitDialog(
    //       titleText: "Confirm changes",
    //       leftAction: () {
    //         String _title = _formKey.currentState!.fields["recipeTitle"]!.value;
    //         String? _description =
    //             _formKey.currentState!.fields["recipeDescription"]?.value;
    //         Provider.of<RecipesProvider>(context, listen: false)
    //             .editRecipe(_title, _description, widget._recipeData.id);
    //         Provider.of<RecipesProvider>(context, listen: false)
    //             .changeEditMode();
    //         Navigator.of(context).pop();
    //       },
    //       rightAction: () {
    //         Provider.of<RecipesProvider>(context, listen: false)
    //             .changeEditMode();
    //         Navigator.of(context).pop();
    //       },
    //       leftText: "Save",
    //       rightText: "Discard",
    //     ),
    //   );
    // }

    Future<bool> _showConfirmDeletePopup() async {
      return await showDialog(
        context: context,
        builder: (context) => ExitDialog(
          titleText: "Confirm delete",
          leftAction: () {
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
          rightAction: () {
            Navigator.of(context).pop(false);
          },
          leftText: "Delete",
          rightText: "Cancel",
        ),
      );
    }

    Future<bool> _onWillPop() async {
      if (Provider.of<RecipesProvider>(context, listen: false).editMode ==
          EditMode.enabled) {
        if (Provider.of<RecipesProvider>(context, listen: false)
                    .formKey
                    .currentState!
                    .fields["recipeTitle"]!
                    .value !=
                recipeData.title ||
            Provider.of<RecipesProvider>(context, listen: false)
                    .formKey
                    .currentState!
                    .fields["recipeDescription"]
                    ?.value !=
                recipeData.description) {
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
            child: FutureBuilder(
              future: RecipeSettingsDatabase.instance
                  .readAllRecipeSettingsForRecipe(recipeData.id!),
              builder: (context, AsyncSnapshot<List<RecipeSettings>> snapshot) {
                return CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverAppBar(
                      backgroundColor: kPrimary,
                      leading: AppBarLeading(
                        function: LeadingFunction.back,
                        onPressed: () {
                          if (Provider.of<RecipesProvider>(context,
                                      listen: false)
                                  .editMode ==
                              EditMode.enabled) {
                            if (Provider.of<RecipesProvider>(context,
                                            listen: false)
                                        .formKey
                                        .currentState!
                                        .fields["recipeTitle"]!
                                        .value !=
                                    recipeData.title ||
                                Provider.of<RecipesProvider>(context,
                                            listen: false)
                                        .formKey
                                        .currentState!
                                        .fields["recipeDescription"]
                                        ?.value !=
                                    recipeData.description) {
                              _showDiscardChangesPopup();
                            } else {
                              Provider.of<RecipesProvider>(context,
                                      listen: false)
                                  .changeEditMode();
                              Navigator.of(context).pop();
                            }
                          } else {
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
                                .formKey
                                .currentState!
                                .validate()) {
                              return;
                            }
                            if (Provider.of<RecipesProvider>(context,
                                        listen: false)
                                    .editMode ==
                                EditMode.enabled) {
                              /// checking if at least one settings value is shown before proceeding
                              if (snapshot.data!.any((coffeeSetting) =>
                                  RecipeSettings.stringToSettingVisibility(
                                      coffeeSetting.visibility) ==
                                  SettingVisibility.shown)) {
                                Recipe updatedRecipe = Recipe(
                                  id: recipeData.id!,
                                  title: Provider.of<RecipesProvider>(context,
                                          listen: false)
                                      .formKey
                                      .currentState!
                                      .fields["recipeTitle"]!
                                      .value,
                                  description: Provider.of<RecipesProvider>(
                                          context,
                                          listen: false)
                                      .formKey
                                      .currentState!
                                      .fields["recipeDescription"]
                                      ?.value,
                                  pushPressure: recipeData.pushPressure,
                                  brewMethod: recipeData.brewMethod,
                                );

                                Provider.of<RecipesProvider>(context,
                                        listen: false)
                                    .editRecipe(updatedRecipe);
                                Provider.of<RecipesProvider>(context,
                                        listen: false)
                                    .changeEditMode();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      "At least one settings bar must be shown",
                                      style: TextStyle(
                                        color: kAccent,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    backgroundColor: kDarkSecondary,
                                    margin: const EdgeInsets.all(10),
                                    elevation: 100,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(kCornerRadius),
                                    ),
                                  ),
                                );
                              }
                            } else {
                              // entering edit mode
                              Provider.of<RecipesProvider>(context,
                                      listen: false)
                                  .changeEditMode();
                            }
                          },
                          icon:
                              (Provider.of<RecipesProvider>(context).editMode ==
                                      EditMode.enabled)
                                  ? Icons.check
                                  : Icons.edit,
                        ),
                        AppBarButton(
                          onTap: () {
                            _showConfirmDeletePopup();
                          },
                          icon: Icons.delete,
                        )
                      ],
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          const Divider(
                            height: 5,
                            color: Color(0x00000000),
                          ),
                          RecipeDetailsHeader(
                            titleValue: recipeData.title,
                            descriptionValue: recipeData.description,
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
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
