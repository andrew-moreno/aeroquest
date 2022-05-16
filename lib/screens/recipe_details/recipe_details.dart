import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import 'package:aeroquest/models/recipe_entry.dart';
import 'package:aeroquest/models/recipes_provider.dart';
import 'package:aeroquest/screens/recipe_details/widgets/recipe_details_body.dart';
import 'package:aeroquest/screens/recipe_details/widgets/recipe_details_header.dart';
import 'package:aeroquest/widgets/appbar/appbar_button.dart';
import 'package:aeroquest/widgets/appbar/appbar_leading.dart';
import 'package:aeroquest/widgets/exit_dialog.dart';
import 'package:aeroquest/constraints.dart';

class RecipeDetails extends StatefulWidget {
  const RecipeDetails({
    Key? key,
    required recipeData,
  })  : _recipeData = recipeData,
        super(key: key);

  final RecipeEntry _recipeData;

  @override
  State<RecipeDetails> createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

    Future<bool> _showDiscardChangesPopup() async {
      return await showDialog(
        context: context,
        builder: (context) => ExitDialog(
          titleText: "Discard changes?",
          leftAction: () => Navigator.of(context).pop(),
          rightAction: () {
            Provider.of<RecipesProvider>(context, listen: false)
                .changeEditMode();
            Navigator.of(context).pop();
          },
        ),
      );
    }

    Future<bool> _showConfirmSavePopup() async {
      return await showDialog(
        context: context,
        builder: (context) => ExitDialog(
          titleText: "Confirm changes",
          leftAction: () {
            String _title = _formKey.currentState!.fields["recipeTitle"]!.value;
            String? _description =
                _formKey.currentState!.fields["recipeDescription"]?.value;
            Provider.of<RecipesProvider>(context, listen: false)
                .editRecipe(_title, _description, widget._recipeData.id);
            Provider.of<RecipesProvider>(context, listen: false)
                .changeEditMode();
            Navigator.of(context).pop();
          },
          rightAction: () {
            Provider.of<RecipesProvider>(context, listen: false)
                .changeEditMode();
            Navigator.of(context).pop();
          },
          leftText: "Save",
          rightText: "Discard",
        ),
      );
    }

    Future<bool> _showConfirmDeletePopup() async {
      return await showDialog(
        context: context,
        builder: (context) => ExitDialog(
          titleText: "Confirm delete",
          leftAction: () {
            Provider.of<RecipesProvider>(context, listen: false)
                .deleteRecipe(widget._recipeData.id);
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
        if (_formKey.currentState!.fields["recipeTitle"]!.value !=
                widget._recipeData.title ||
            _formKey.currentState!.fields["recipeDescription"]?.value !=
                widget._recipeData.description) {
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
                  leading: (Provider.of<RecipesProvider>(context).editMode ==
                          EditMode.disabled)
                      ? const AppBarLeading(function: LeadingFunction.back)
                      : Container(),
                  actions: [
                    AppBarButton(
                      onTap: () {
                        // exiting edit mode
                        // checks if any changes made before showing popup
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        if (Provider.of<RecipesProvider>(context, listen: false)
                                    .editMode ==
                                EditMode.enabled &&
                            (_formKey.currentState!.fields["recipeTitle"]!
                                        .value !=
                                    widget._recipeData.title ||
                                _formKey.currentState!
                                        .fields["recipeDescription"]?.value !=
                                    widget._recipeData.description)) {
                          _showConfirmSavePopup();
                        } else {
                          // entering edit mode

                          Provider.of<RecipesProvider>(context, listen: false)
                              .changeEditMode();
                        }
                      },
                      icon:
                          (Provider.of<RecipesProvider>(context, listen: false)
                                      .editMode ==
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
                        titleValue: widget._recipeData.title,
                        descriptionValue: widget._recipeData.description,
                        formKey: _formKey,
                      ),
                      const Divider(
                        height: 20,
                        color: Color(0x00000000),
                      ),
                      RecipeDetailsBody(
                        recipeData: widget._recipeData,
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
