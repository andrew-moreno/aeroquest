import 'package:aeroquest/screens/recipe_details/recipe_details_body/body_widgets/bean_settings_group.dart';
import 'package:aeroquest/screens/recipe_details/recipe_details_body/body_widgets/recipe_method.dart';
import 'package:aeroquest/screens/recipe_details/recipe_details_header.dart';
import 'package:aeroquest/widgets/appbar/appbar_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:aeroquest/providers/recipes_provider.dart';
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

  late final RecipesProvider _recipesProvider =
      Provider.of<RecipesProvider>(context, listen: false);

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
          /// Popping dialog box
          Navigator.of(context).pop(true);

          /// Popping back to Recipes page
          if (!isOsBackPressed || widget.isAdding) {
            Navigator.of(context).pop(true);
          } else {
            _recipesProvider.setEditMode(EditMode.disabled);
            _recipesProvider.clearTempData();
            setState(() {});
          }
        },
      ),
    );
  }

  /// Displays a dialog box used to confirm deletion of this recipe
  Future<void> _showConfirmDeletePopup() async {
    return await showDialog(
      context: context,
      builder: (context) => CustomDialog(
        titleText: "Confirm delete",
        leftAction: () => Navigator.of(context).pop(false),
        rightAction: () async {
          /// Close dialog, then go back to recipes page
          Navigator.of(context)
            ..pop(false)
            ..pop(false);
          await _recipesProvider.deleteRecipe(widget.recipeData.id!);
        },
        leftButtonText: "Cancel",
        rightButtonText: "Delete",
      ),
    );
  }

  /// Checks if this recipe has changed by comparing to the initial data
  /// passed to this widget
  bool _isRecipeChanged() {
    return _recipesProvider.isRecipeChanged(
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
    if (_recipesProvider.editMode == EditMode.enabled) {
      if (_isRecipeChanged()) {
        _showDiscardChangesPopup(true);
      } else {
        if (widget.isAdding) {
          return Future.value(true);
        }
        return Future.value(false);
      }
    }
    return Future.value(true);
  }

  /// Function to be executed when pressing the back button within the UI
  ///
  /// Implementation is very similar to [_onWillPop()]. Changes made here
  /// should be reflected in that function
  void _exitDetailsPage() {
    if (_recipesProvider.editMode == EditMode.enabled && _isRecipeChanged()) {
      _showDiscardChangesPopup(false);
    } else {
      Navigator.of(context).pop();
    }
  }

  /// Function to be executed when pressing the edit button
  void _editRecipe() {
    _recipesProvider.setTempRecipe(widget.recipeData.id!);

    _recipesProvider.setEditMode(EditMode.enabled);
    setState(() {});
  }

  /// Function to be executed when pressing the save button
  ///
  /// Assums that the edit mode is enabled
  Future<void> _saveRecipe() async {
    // checks if any changes made before showing popup
    if (!_recipesProvider.recipeIdentifiersFormKey.currentState!.validate()) {
      return;
    }
    await _recipesProvider.saveRecipe();
    _recipesProvider.setEditMode(EditMode.disabled);
    setState(() {});
  }

  @override
  void dispose() {
    _recipesProvider.setEditMode(EditMode.disabled);
    _recipesProvider.clearTempData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> tabs = <String>['Bean Settings', 'Method'];
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        body: WillPopScope(
          onWillPop: _onWillPop,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SafeArea(
              child: NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverOverlapAbsorber(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context),
                      sliver: SliverAppBar(
                        backgroundColor: kPrimary,
                        leading: AppBarLeading(
                          leadingFunction: LeadingFunction.back,
                          onTap: () => _exitDetailsPage(),
                        ),
                        actions: [
                          AppBarButton(
                            onTap: () async {
                              if (_recipesProvider.editMode ==
                                  EditMode.enabled) {
                                await _saveRecipe();
                              } else {
                                _editRecipe();
                              }
                            },
                            icon:
                                (_recipesProvider.editMode == EditMode.enabled)
                                    ? Icons.check
                                    : Icons.edit,
                            hasDynamicColour: true,
                          ),
                          (!widget.isAdding)
                              ? AppBarButton(
                                  onTap: _showConfirmDeletePopup,
                                  icon: Icons.delete,
                                  hasDynamicColour: true,
                                )
                              : Container(),
                        ],
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          const SizedBox(height: 5),
                          RecipeDetailsHeader(
                            titleValue: _recipesProvider
                                    .recipes[widget.recipeData.id]?.title ??
                                widget.recipeData.title,
                            descriptionValue: _recipesProvider
                                    .recipes[widget.recipeData.id]
                                    ?.description ??
                                widget.recipeData.description ??
                                "",
                          ),
                          const SizedBox(height: 20),
                          Container(
                            color: kDarkSecondary,
                            child: TabBar(
                              tabs: tabs
                                  .map((String name) => Tab(text: name))
                                  .toList(),
                              labelStyle: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15),
                              labelColor: kAccent,
                              unselectedLabelColor: kPrimary,
                              indicatorColor: kAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ];
                },
                body: Container(
                  color: kDarkSecondary,
                  child: TabBarView(
                    children: [
                      RecipeDetailsBodyChild(
                        header: "Bean Settings",
                        child: BeanSettingsGroup(
                          recipeEntryId: widget.recipeData.id!,
                        ),
                      ),
                      RecipeDetailsBodyChild(
                        header: "Method",
                        child: RecipeMethod(
                          recipeEntryId: widget.recipeData.id!,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RecipeDetailsBodyChild extends StatelessWidget {
  const RecipeDetailsBodyChild({
    Key? key,
    required this.header,
    required this.child,
  }) : super(key: key);

  final String header;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: Builder(
        builder: (context) {
          return CustomScrollView(
            slivers: [
              SliverOverlapInjector(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        Text(
                          header,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        const SizedBox(height: 15),
                        child,
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
