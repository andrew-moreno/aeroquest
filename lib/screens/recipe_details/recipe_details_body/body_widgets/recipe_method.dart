import 'package:aeroquest/providers/recipes_provider.dart';
import 'package:aeroquest/widgets/animated_vertical_toggle.dart';
import 'package:flutter/material.dart';

import 'package:aeroquest/models/recipe.dart';
import 'package:aeroquest/models/note.dart';
import 'package:aeroquest/constraints.dart';
import 'package:provider/provider.dart';

class RecipeMethod extends StatefulWidget {
  const RecipeMethod({Key? key}) : super(key: key);

  static const double _methodPadding = 15;

  @override
  State<RecipeMethod> createState() => _RecipeMethodState();
}

class _RecipeMethodState extends State<RecipeMethod> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Consumer<RecipesProvider>(
        builder: (_, recipesProvider, ___) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RecipeMethodDescription(
                    description: "Push Pressure",
                    data: recipesProvider.tempPushPressure,
                  ),
                  const VerticalDivider(
                    color: Color(0x00000000),
                    thickness: 10,
                  ),
                  RecipeMethodDescription(
                    description: "Brew Method",
                    data: recipesProvider.tempBrewMethod,
                  ),
                ],
              ),
              // const Divider(
              //   color: Color(0x00000000),
              //   height: RecipeMethod._methodPadding,
              // ),
              // ListView.separated(
              //   physics: const BouncingScrollPhysics(),
              //   shrinkWrap: true,
              //   itemCount: widget.notes.length,
              //   itemBuilder: (BuildContext context, int index) {
              //     return RecipeMethodNotes(note: widget.notes[index]);
              //   },
              //   separatorBuilder: (context, index) {
              //     return const Divider(
              //       color: Color(0x00000000),
              //       height: RecipeMethod._methodPadding,
              //     );
              //   },
              // )
            ],
          );
        },
      ),
    );
  }
}

// template for push pressure and brew method text
class RecipeMethodDescription extends StatelessWidget {
  const RecipeMethodDescription({
    Key? key,
    required this.description,
    required this.data,
  }) : super(key: key);

  final String description;
  final dynamic data;

  String _enumTextConvert(dynamic action) {
    switch (action) {
      case PushPressure.light:
        return "Light";

      case PushPressure.heavy:
        return "Heavy";
      case BrewMethod.regular:
        return "Regular";
      case BrewMethod.inverted:
        return "Inverted";

      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> _pushPressureToggleValues = [
      _enumTextConvert(PushPressure.light),
      _enumTextConvert(PushPressure.heavy),
    ];
    List<String> _brewMethodToggleValues = [
      _enumTextConvert(BrewMethod.regular),
      _enumTextConvert(BrewMethod.inverted),
    ];

    Widget displayToggle(BuildContext context) {
      if (data.runtimeType == BrewMethod) {
        return AnimatedVerticalToggle(
          values: _brewMethodToggleValues,
          onToggleCallback: (index) {
            index == 0
                ? Provider.of<RecipesProvider>(context, listen: false)
                    .tempBrewMethod = BrewMethod.regular
                : Provider.of<RecipesProvider>(context, listen: false)
                    .tempBrewMethod = BrewMethod.inverted;
          },
          initialPosition: (Provider.of<RecipesProvider>(context, listen: false)
                      .tempBrewMethod ==
                  BrewMethod.regular)
              ? Position.top
              : Position.bottom,
        );
      } else {
        return AnimatedVerticalToggle(
          values: _pushPressureToggleValues,
          onToggleCallback: (index) {
            index == 0
                ? Provider.of<RecipesProvider>(context, listen: false)
                    .tempPushPressure = PushPressure.light
                : Provider.of<RecipesProvider>(context, listen: false)
                    .tempPushPressure = PushPressure.heavy;
          },
          initialPosition: (Provider.of<RecipesProvider>(context, listen: false)
                      .tempPushPressure ==
                  PushPressure.light)
              ? Position.top
              : Position.bottom,
        );
      }
    }

    return Column(
      children: [
        Text(
          description,
          style:
              Theme.of(context).textTheme.subtitle2!.copyWith(color: kSubtitle),
        ),
        (Provider.of<RecipesProvider>(context, listen: false).editMode ==
                EditMode.enabled)
            ? displayToggle(context)
            : Text(
                _enumTextConvert(data),
                style: Theme.of(context)
                    .textTheme
                    .subtitle2!
                    .copyWith(color: kAccent),
              ),
      ],
    );
  }
}

class RecipeMethodNotes extends StatelessWidget {
  const RecipeMethodNotes({Key? key, required this.note}) : super(key: key);

  final Note note;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: kLightSecondary,
        borderRadius: BorderRadius.circular(kCornerRadius),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              note.time.toString(),
              style: const TextStyle(
                color: kPrimary,
                fontSize: 17,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w600,
              ),
            ),
            const VerticalDivider(
              width: 20,
              color: Color(0x00000000),
            ),
            Expanded(
              child: Text(
                note.text,
                style: const TextStyle(
                  color: kPrimary,
                  fontSize: 13,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
