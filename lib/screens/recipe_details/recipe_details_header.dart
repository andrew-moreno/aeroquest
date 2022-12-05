import 'package:control_style/decorated_input_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:aeroquest/providers/recipes_provider.dart';
import 'package:aeroquest/constraints.dart';

class RecipeDetailsHeader extends StatelessWidget {
  /// Defines the widget that contains the title and description for a recipe
  const RecipeDetailsHeader({
    Key? key,
    required this.titleValue,
    required this.descriptionValue,
  }) : super(key: key);

  /// The value of the title when the details page is opened
  final String titleValue;

  /// The value of the description when the details page is opened
  final String? descriptionValue;

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
  );

  static const double? _sizedBoxHeight = 10;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: (Provider.of<RecipesProvider>(context, listen: false).editMode ==
              EditMode.enabled)
          ? FormBuilder(
              key: Provider.of<RecipesProvider>(context, listen: false)
                  .recipeIdentifiersFormKey,
              child: Column(
                children: [
                  CustomHeaderFormField(
                    name: "recipeTitle",
                    initialValue: titleValue,
                    hintText: "Title",
                    textStyle: _titleTextStyle,
                    validate: true,
                    textCapitalization: TextCapitalization.words,
                    validateUniqueness: true,
                  ),
                  const SizedBox(height: _sizedBoxHeight),
                  CustomHeaderFormField(
                    name: "recipeDescription",
                    initialValue: descriptionValue,
                    hintText: "Description",
                    textStyle: _descriptionTextStyle,
                    validate: false,
                    textCapitalization: TextCapitalization.sentences,
                    validateUniqueness: false,
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Text(titleValue, style: _titleTextStyle),
                const SizedBox(height: _sizedBoxHeight),
                (descriptionValue != null && descriptionValue != "")
                    ? Text(
                        descriptionValue!,
                        style: _descriptionTextStyle,
                      )
                    : Container(),
              ],
            ),
    );
  }
}

class CustomHeaderFormField extends StatelessWidget {
  /// Defines the widget used for editing the recipe title and description
  const CustomHeaderFormField({
    Key? key,
    required this.name,
    required this.initialValue,
    required this.hintText,
    required this.textStyle,
    required this.validate,
    required this.textCapitalization,
    required this.validateUniqueness,
  }) : super(key: key);

  // TODO: comments
  final String name;
  final String? initialValue;
  final String hintText;
  final TextStyle textStyle;
  final bool validate;
  final TextCapitalization textCapitalization;

  /// Whether to check if the entered text already exists within the app
  final bool validateUniqueness;

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: name,
      textCapitalization: textCapitalization,
      cursorColor: kLightSecondary,
      cursorWidth: 2,
      maxLines: null,
      textAlign: TextAlign.center,
      initialValue: initialValue,
      style: textStyle,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(5),
        hintText: hintText,
        hintStyle: textStyle,
        filled: true,
        fillColor: kPrimary,
        border: DecoratedInputBorder(
          shadow: [kBoxShadow],
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
          // TODO: make more efficient
          if (value != initialValue &&
              Provider.of<RecipesProvider>(context, listen: false)
                  .recipes
                  .values
                  .any((recipe) => recipe.title == value)) {
            return "Please select a unique recipe title";
          }
        }
        return null;
      },
    );
  }
}
