import 'package:flutter/material.dart';

import 'package:aeroquest/models/recipe.dart';
import 'package:aeroquest/models/note.dart';
import 'package:aeroquest/constraints.dart';

class RecipeMethod extends StatelessWidget {
  const RecipeMethod({
    Key? key,
    required this.pushPressure,
    required this.brewMethod,
    required this.notes,
  }) : super(key: key);

  final PushPressure pushPressure;
  final BrewMethod brewMethod;
  final List<Note> notes;

  static const double _methodPadding = 15;

  String _pushPressureText(PushPressure action) {
    switch (action) {
      case PushPressure.light:
        return "Light";
      case PushPressure.moderate:
        return "Moderate";
      case PushPressure.heavy:
        return "Heavy";

      default:
        return "";
    }
  }

  String _brewMethodText(BrewMethod action) {
    switch (action) {
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RecipeMethodDescription(
                description: "Push Pressure",
                data: _pushPressureText(pushPressure),
              ),
              const VerticalDivider(
                color: Color(0x00000000),
                thickness: 10,
              ),
              RecipeMethodDescription(
                description: "Brew Method  ",
                data: _brewMethodText(brewMethod),
              ),
            ],
          ),
          const Divider(
            color: Color(0x00000000),
            height: _methodPadding,
          ),
          ListView.separated(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: notes.length,
            itemBuilder: (BuildContext context, int index) {
              return RecipeMethodNotes(note: notes[index]);
            },
            separatorBuilder: (context, index) {
              return const Divider(
                color: Color(0x00000000),
                height: _methodPadding,
              );
            },
          )
        ],
      ),
    );
  }
}

// template for push pressure and brew method text
class RecipeMethodDescription extends StatelessWidget {
  const RecipeMethodDescription({Key? key, required description, required data})
      : _description = description,
        _data = data,
        super(key: key);

  final String _description;
  final String _data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          _description,
          style: const TextStyle(
            color: kSubtitle,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        Text(
          _data,
          style: const TextStyle(
            color: kAccent,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
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
