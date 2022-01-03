import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/models/recipe.dart';
import 'package:flutter/material.dart';

class RecipeMethod extends StatelessWidget {
  const RecipeMethod({
    Key? key,
    required this.pushPressure,
    required this.brewMethod,
    required this.notes,
  }) : super(key: key);

  final PushPressure pushPressure;
  final BrewMethod brewMethod;
  final List<Notes> notes;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      padding: const EdgeInsets.only(
        top: 5,
        bottom: 15,
        left: 15,
        right: 15,
      ),
      decoration: const BoxDecoration(
        color: kDarkNavy,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Column(
        children: [
          const Text(
            "Method",
            style: TextStyle(
                color: Color.fromRGBO(
                  // subtitle color with higher opacity
                  217,
                  204,
                  191,
                  0.75,
                ),
                fontFamily: "Spectral",
                fontSize: 18,
                fontWeight: FontWeight.w600),
          ),
          const Divider(
            thickness: 1,
            color: kDarkSubtitleColor,
            height: 8,
          ),
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _RecipeMethodDescriptionTemplate(
                  description: "Push Pressure",
                  data: () {
                    if (pushPressure == PushPressure.weak) {
                      return "Weak";
                    } else if (pushPressure == PushPressure.medium) {
                      return "Medium";
                    }
                    return "Strong";
                  }(),
                ),
                const VerticalDivider(
                  color: kDarkSubtitleColor,
                  thickness: 1,
                  indent: 6,
                  endIndent: 6,
                ),
                _RecipeMethodDescriptionTemplate(
                  description: "Brew Method  ",
                  data: () {
                    if (brewMethod == BrewMethod.regular) {
                      return "Regular";
                    }
                    return "Inverted";
                  }(),
                ),
              ],
            ),
          ),
          const Divider(
            color: Color(0x00000000),
            height: 15,
          ),
          ListView.separated(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: notes.length,
            itemBuilder: (BuildContext context, int index) {
              return _RecipeMethodNotes(notes: notes, index: index);
            },
            separatorBuilder: (context, index) {
              return const Divider(
                color: Color(0x00000000),
                height: 15,
              );
            },
          )
        ],
      ),
    );
  }
}

class _RecipeMethodNotes extends StatelessWidget {
  const _RecipeMethodNotes({Key? key, required this.notes, required this.index})
      : super(key: key);

  final List<Notes> notes;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: kMediumNavy,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              notes[index].time,
              style: const TextStyle(
                color: kTextColor,
                fontSize: 18,
                fontFamily: "Spectral",
                fontWeight: FontWeight.w600,
              ),
            ),
            const VerticalDivider(
              color: kDarkSubtitleColor,
              width: 20,
              thickness: 1,
              indent: 3,
              endIndent: 3,
            ),
            Expanded(
              child: Text(
                notes[index].note,
                style: const TextStyle(
                  color: kTextColor,
                  fontSize: 13,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecipeMethodDescriptionTemplate extends StatelessWidget {
  const _RecipeMethodDescriptionTemplate({
    Key? key,
    required this.description,
    required this.data,
  }) : super(key: key);

  final String description;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          description,
          style: const TextStyle(
            color: kDarkSubtitleColor,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        Text(
          data,
          style: const TextStyle(
            color: kAccentOrange,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
