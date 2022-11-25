import 'package:aeroquest/widgets/appbar/appbar_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:aeroquest/providers/recipes_provider.dart';
import 'package:aeroquest/screens/recipe_details/recipe_details_body/recipe_details_body.dart';
import 'package:aeroquest/screens/recipe_details/recipe_details_header.dart';
import 'package:aeroquest/widgets/appbar/appbar_leading.dart';
import 'package:aeroquest/widgets/custom_dialog.dart';
import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/models/recipe.dart';

class RecipeDetails extends StatefulWidget {
  /// The screen used for displaying and editing the details of a single recipe
  const RecipeDetails({
    Key? key,
    required this.recipeData,
    required this.isAdding,
  }) : super(key: key);

  /// Data for this particular recipe
  final Recipe recipeData;

  /// Whether this recipe is being added or edited
  ///
  /// If true, user is adding this recipe for the first time. Otherwise,
  /// this recipe is being edited or viewed
  final bool isAdding;

  @override
  State<RecipeDetails> createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {
  final ScrollController _scrollController = ScrollController();

  /// uesd for calling [clearTempNotesAndRecipeSettings()] in the dispose
  /// method
  late RecipesProvider _recipesProvider;

  @override
  void initState() {
    _recipesProvider = Provider.of<RecipesProvider>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    _recipesProvider.clearTempNotesAndRecipeSettings();
    super.dispose();
  }

  /// Displays a dialog box used to confirm leaving the details page when
  /// changes have been made to the recipe without saving
  ///
  /// [isOsBackPressed] used to differentiate between the UI back button and
  /// the operating system back button
  Future<void> _showDiscardChangesPopup(bool isOsBackPressed) async {
    return await showDialog(
      context: context,
      builder: (context) => CustomDialog(
        titleText: "Discard changes?",
        leftAction: () => Navigator.of(context).pop(false),
        rightAction: () {
          Provider.of<RecipesProvider>(context, listen: false).changeEditMode();
          Provider.of<RecipesProvider>(context, listen: false)
              .setTempRecipe(widget.recipeData.id!);
          Provider.of<RecipesProvider>(context, listen: false)
              .setTempRecipeSettings(widget.recipeData.id!);
          Provider.of<RecipesProvider>(context, listen: false)
              .setTempNotes(widget.recipeData.id!);
          Navigator.of(context).pop(true);
          if (!isOsBackPressed || widget.isAdding) {
            Navigator.of(context).pop(true);
          }
        },
      ),
    );
  }

  /// Displays a dialog box used to confirm deletion of this recipe
  ///
  ///
  Future<void> _showConfirmDeletePopup() async {
    return await showDialog(
      context: context,
      builder: (context) => CustomDialog(
        titleText: "Confirm delete",
        leftAction: () => Navigator.of(context).pop(false),
        rightAction: () {
          Provider.of<RecipesProvider>(context, listen: false)
              .deleteRecipe(widget.recipeData.id!);

          /// Close dialog, then go back to recipes page
          Navigator.of(context).pop(false);
          Navigator.of(context).pop(false);
          if (Provider.of<RecipesProvider>(context, listen: false).editMode ==
              EditMode.enabled) {
            Provider.of<RecipesProvider>(context, listen: false)
                .changeEditMode();
          }
        },
        leftButtonText: "Cancel",
        rightButtonText: "Delete",
      ),
    );
  }

  /// Checks if this recipe has changed by comparing to the initial data
  /// passed to this widget
  bool _isRecipeChanged() {
    return Provider.of<RecipesProvider>(context, listen: false).isRecipeChanged(
      originalTitle: widget.recipeData.title,
      originalDescription: widget.recipeData.description,
      originalPushPressure:
          Recipe.stringToPushPressure(widget.recipeData.pushPressure),
      originalBrewMethod:
          Recipe.stringToBrewMethod(widget.recipeData.brewMethod),
      recipeId: widget.recipeData.id!,
    );
  }

  /// Function to be executed when pressing the OS back button
  ///
  /// Implementation is very similar to [_exitDetailsPage()]. Changes made here
  /// should be reflected in that function
  Future<bool> _onWillPop() async {
    if (Provider.of<RecipesProvider>(context, listen: false).editMode ==
        EditMode.enabled) {
      if (_isRecipeChanged()) {
        _showDiscardChangesPopup(true);
      } else {
        Provider.of<RecipesProvider>(context, listen: false).changeEditMode();

        if (widget.isAdding) {
          return Future.value(true);
        }
        return Future.value(false);
      }
    }
    Provider.of<RecipesProvider>(context, listen: false)
        .clearTempNotesAndRecipeSettings();
    return Future.value(true);
  }

  /// Function to be executed when pressing the back button within the UI
  ///
  /// Implementation is very similar to [_onWillPop()]. Changes made here
  /// should be reflected in that function
  void _exitDetailsPage() {
    if (Provider.of<RecipesProvider>(context, listen: false).editMode ==
        EditMode.enabled) {
      if (_isRecipeChanged()) {
        _showDiscardChangesPopup(false);
      } else {
        Provider.of<RecipesProvider>(context, listen: false).changeEditMode();
        Provider.of<RecipesProvider>(context, listen: false)
            .clearTempNotesAndRecipeSettings();
        Navigator.of(context).pop();
      }
    } else {
      Provider.of<RecipesProvider>(context, listen: false)
          .clearTempNotesAndRecipeSettings();
      Navigator.of(context).pop();
    }
  }

  /// Function to be executed when pressing the save button
  void _saveRecipe() {
    // exiting edit mode
    // checks if any changes made before showing popup
    if (!Provider.of<RecipesProvider>(context, listen: false)
        .recipeIdentifiersFormKey
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SafeArea(
            child: StretchingOverscrollIndicator(
              axisDirection: AxisDirection.down,
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverAppBar(
                    backgroundColor: kPrimary,
                    leading: AppBarLeading(
                      leadingFunction: LeadingFunction.back,
                      onTap: () => _exitDetailsPage(),
                    ),
                    actions: [
                      AppBarButton(
                        onTap: () => _saveRecipe(),
                        icon: (Provider.of<RecipesProvider>(context).editMode ==
                                EditMode.enabled)
                            ? Icons.check
                            : Icons.edit,
                      ),
                      (!widget.isAdding)
                          ? AppBarButton(
                              onTap: () => _showConfirmDeletePopup(),
                              icon: Icons.delete,
                            )
                          : Container(),
                    ],
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        const SizedBox(height: 5),
                        Consumer<RecipesProvider>(
                          builder: (_, recipesProvider, ___) {
                            return RecipeDetailsHeader(
                              titleValue: recipesProvider.recipes
                                  .firstWhere(
                                    (recipe) =>
                                        recipe.id == widget.recipeData.id,
                                    orElse: () => widget.recipeData,
                                  )
                                  .title,
                              descriptionValue: recipesProvider.recipes
                                      .firstWhere(
                                        (recipe) =>
                                            recipe.id == widget.recipeData.id,
                                        orElse: () => widget.recipeData,
                                      )
                                      .description ??
                                  "",
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        RecipeDetailsBody(
                          recipeId: widget.recipeData.id!,
                        ),
                      ],
                    ),
                  ),

                  /// Fills remaining space if content doesn't expand to
                  /// height of screen
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: kDarkSecondary,
                        // Necessary to fix 1 pixel gap bug in slivers
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
      ),
    );
  }
}
