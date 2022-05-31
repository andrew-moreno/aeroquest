import 'package:control_style/decorated_input_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:aeroquest/providers/recipes_provider.dart';
import 'package:aeroquest/constraints.dart';

class RecipeDetailsHeader extends StatelessWidget {
  const RecipeDetailsHeader(
      {Key? key, required titleValue, descriptionValue, required formKey})
      : _titleValue = titleValue,
        _descriptionValue = descriptionValue,
        _formKey = formKey,
        super(key: key);

  final String _titleValue;
  final String? _descriptionValue;
  final GlobalKey<FormBuilderState> _formKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: FormBuilder(
        key: _formKey,
        child: Column(
          children: [
            CustomFormField(
              name: "recipeTitle",
              initialValue: _titleValue,
              hintText: "Title",
              textStyle: const TextStyle(
                  color: kLightSecondary,
                  fontFamily: "Spectral",
                  fontSize: 35,
                  fontWeight: FontWeight.w700,
                  height: 1.2),
              validate: true,
            ),
            const Divider(
              height: 10,
              color: Color(0x00000000),
            ),
            ((_descriptionValue != null && _descriptionValue != "") ||
                    Provider.of<RecipesProvider>(context).editMode ==
                        EditMode.enabled)
                ? CustomFormField(
                    name: "recipeDescription",
                    initialValue: _descriptionValue,
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
      ),
    );
  }
}

class CustomFormField extends StatelessWidget {
  const CustomFormField(
      // make either title or description
      {Key? key,
      required name,
      required initialValue,
      required hintText,
      required textStyle,
      required validate})
      : _name = name,
        _initialValue = initialValue,
        _hintText = hintText,
        _textStyle = textStyle,
        _validate = validate,
        super(key: key);

  final String _name;
  final String _initialValue;
  final String _hintText;
  final TextStyle _textStyle;
  final bool _validate;

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipesProvider>(
      builder: (context, recipes, child) {
        return FormBuilderTextField(
          name: _name,
          cursorColor: kLightSecondary,
          cursorWidth: 2,
          enabled: (recipes.editMode == EditMode.enabled) ? true : false,
          maxLines: null,
          textAlign: TextAlign.center,
          initialValue: _initialValue,
          style: _textStyle,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(5),
            hintText: _hintText,
            hintStyle: _textStyle,
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
            if (_validate && (value == null || value.isEmpty)) {
              return "Please enter a title";
            }
            return null;
          },
        );
      },
    );
  }
}
