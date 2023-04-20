import 'package:aeroquest/models/recipe.dart';
import 'package:aeroquest/providers/recipes_provider.dart';
import 'package:aeroquest/constraints.dart';

import 'package:control_style/decorated_input_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class RecipeDetailsHeader extends StatefulWidget {
  /// Defines the widget that contains the title and description for a recipe
  const RecipeDetailsHeader({
    Key? key,
    required this.recipeData,
  }) : super(key: key);

  /// Recipe data to be displayed by this widget
  final Recipe recipeData;

  static const _titleTextStyle = TextStyle(
    color: kLightSecondary,
    fontFamily: "Spectral",
    fontSize: 35,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  static const _descriptionTextStyle = TextStyle(
    color: kLightSecondary,
    fontFamily: "Poppins",
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static const double _sizedBoxHeight = 10;

  @override
  State<RecipeDetailsHeader> createState() => _RecipeDetailsHeaderState();
}

class _RecipeDetailsHeaderState extends State<RecipeDetailsHeader> {
  late final RecipesProvider _recipesProvider =
      Provider.of<RecipesProvider>(context, listen: false);

  /// Returns a bool highlighting if the the edit mode is enabled or not
  bool isEditModeEnabled() {
    return (_recipesProvider.editMode == EditMode.enabled);
  }

  @override
  void initState() {
    /// Setting initial value of the title form field
    _recipesProvider.recipeTitleController.text =
        _recipesProvider.recipes[widget.recipeData.id]?.title ??
            widget.recipeData.title;

    /// Setting the initial value of the description form field
    _recipesProvider.recipeDescriptionController.text =
        _recipesProvider.recipes[widget.recipeData.id]?.description ??
            widget.recipeData.description ??
            "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: FormBuilder(
        key: Provider.of<RecipesProvider>(context, listen: false)
            .recipeIdentifiersFormKey,
        child: Column(
          children: [
            CustomHeaderFormField(
              name: "recipeTitle",
              hintText: "Title",
              hintStyle: RecipeDetailsHeader._titleTextStyle,
              controller: Provider.of<RecipesProvider>(context, listen: false)
                  .recipeTitleController,
              validate: true,
              textCapitalization: TextCapitalization.words,
              validateUniqueness: true,
              enabled: isEditModeEnabled(),
            ),
            const SizedBox(height: RecipeDetailsHeader._sizedBoxHeight),
            Opacity(
              opacity: (isEditModeEnabled() ||
                      (_recipesProvider
                          .recipeDescriptionController.text.isNotEmpty))
                  ? 1
                  : 0,
              child: CustomHeaderFormField(
                name: "recipeDescription",
                hintText: "Description",
                hintStyle: RecipeDetailsHeader._descriptionTextStyle,
                controller: Provider.of<RecipesProvider>(context, listen: false)
                    .recipeDescriptionController,
                validate: false,
                textCapitalization: TextCapitalization.sentences,
                validateUniqueness: false,
                enabled: isEditModeEnabled(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomHeaderFormField extends StatelessWidget {
  /// Defines the widget used for editing the recipe title and description
  const CustomHeaderFormField({
    Key? key,
    required this.name,
    required this.hintText,
    required this.hintStyle,
    required this.validate,
    required this.textCapitalization,
    required this.validateUniqueness,
    required this.enabled,
    required this.controller,
  }) : super(key: key);

  final String name;
  final String hintText;
  final TextStyle hintStyle;
  final TextCapitalization textCapitalization;
  final bool enabled;
  final TextEditingController controller;

  /// Whether input should be validated before submission or not
  final bool validate;

  /// Whether to check if the entered text already exists within the app
  final bool validateUniqueness;

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      controller: controller,
      enabled: enabled,
      name: name,
      textCapitalization: textCapitalization,
      cursorColor: kLightSecondary,
      maxLines: null,
      textAlign: TextAlign.center,
      style: hintStyle,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.all(6),
        hintText: hintText,
        hintStyle: hintStyle,
        fillColor: kPrimary,
        border: DecoratedInputBorder(
          shadow: (enabled) ? [kBoxShadow] : [],
          child: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kCornerRadius),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      validator: (value) {
        if (validate && (value == null || value.isEmpty)) {
          return "Please enter a title";
        } else if (validateUniqueness) {
          if (value != controller.text &&
              Provider.of<RecipesProvider>(context, listen: false)
                  .recipes
                  .values
                  .any((recipe) => recipe.title == value)) {
            return "Please enter a unique recipe title";
          }
        }
        return null;
      },
    );
  }
}
