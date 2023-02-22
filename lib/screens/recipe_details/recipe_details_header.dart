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
    height: 1.4,
  );

  static const double _sizedBoxHeight = 10;

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
                    hintStyle: _titleTextStyle,
                    validate: true,
                    textCapitalization: TextCapitalization.words,
                    validateUniqueness: true,
                  ),
                  const SizedBox(height: _sizedBoxHeight),
                  CustomHeaderFormField(
                    name: "recipeDescription",
                    initialValue: descriptionValue,
                    hintText: "Description",
                    hintStyle: _descriptionTextStyle,
                    validate: false,
                    textCapitalization: TextCapitalization.sentences,
                    validateUniqueness: false,
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  Text(
                    titleValue,
                    style: _titleTextStyle,
                    textAlign: TextAlign.center,
                  ),
                  // 5*2 used to match padding of text form fields
                  const SizedBox(height: _sizedBoxHeight + (5 * 2)),
                  Opacity(
                    opacity:
                        (descriptionValue != null && descriptionValue != "")
                            ? 1
                            : 0,
                    child: Text(
                      descriptionValue!,
                      style: _descriptionTextStyle,
                      textAlign: TextAlign.center,
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
    required this.initialValue,
    required this.hintText,
    required this.hintStyle,
    required this.validate,
    required this.textCapitalization,
    required this.validateUniqueness,
  }) : super(key: key);

  final String name;
  final String? initialValue;
  final String hintText;
  final TextStyle hintStyle;
  final TextCapitalization textCapitalization;

  /// Whether input should be validated before submission or not
  final bool validate;

  /// Whether to check if the entered text already exists within the app
  final bool validateUniqueness;

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: name,
      textCapitalization: textCapitalization,
      cursorColor: kLightSecondary,
      maxLines: null,
      textAlign: TextAlign.center,
      initialValue: initialValue,
      style: hintStyle,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.all(5),
        hintText: hintText,
        hintStyle: hintStyle,
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
          if (value != initialValue &&
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
