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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Consumer<RecipesProvider>(
        builder: (_, recipesProvider, ___) {
          return FormBuilder(
            key: recipesProvider.recipeIdentifiersFormKey,
            child: Column(
              children: [
                CustomHeaderFormField(
                  name: "recipeTitle",
                  initialValue: titleValue,
                  hintText: "Title",
                  textStyle: const TextStyle(
                      color: kLightSecondary,
                      fontFamily: "Spectral",
                      fontSize: 35,
                      fontWeight: FontWeight.w700,
                      height: 1.2),
                  validate: true,
                ),
                const SizedBox(height: 10),
                ((descriptionValue != null && descriptionValue != "") ||
                        recipesProvider.editMode == EditMode.enabled)
                    ? CustomHeaderFormField(
                        name: "recipeDescription",
                        initialValue: descriptionValue,
                        hintText: "Description",
                        textStyle: const TextStyle(
                          color: kLightSecondary,
                          fontFamily: "Poppins",
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        validate: false,
                      )
                    : Container(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CustomHeaderFormField extends StatelessWidget {
  /// Defines the widget used for editing the recipe title and description
  const CustomHeaderFormField(
      // make either title or description
      {Key? key,
      required this.name,
      required this.initialValue,
      required this.hintText,
      required this.textStyle,
      required this.validate})
      : super(key: key);

  final String name;
  final String? initialValue;
  final String hintText;
  final TextStyle textStyle;
  final bool validate;

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipesProvider>(
      builder: (_, recipes, __) {
        return FormBuilderTextField(
          name: name,
          cursorColor: kLightSecondary,
          cursorWidth: 2,
          enabled: (recipes.editMode == EditMode.enabled) ? true : false,
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
              shadow:
                  (recipes.editMode == EditMode.enabled) ? [kBoxShadow] : [],
              child: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kCornerRadius),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          validator: (value) {
            if (validate && (value == null || value.isEmpty)) {
              return "Please enter a title";
            }
            return null;
          },
        );
      },
    );
  }
}
