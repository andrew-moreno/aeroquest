import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/models/recipe.dart';
import 'package:flutter/material.dart';

class RecipeMethod extends StatelessWidget {
  const RecipeMethod({
    Key? key,
    required pushPressure,
    required brewMethod,
    required notes,
  })  : _pushPressure = pushPressure,
        _brewMethod = brewMethod,
        _notes = notes,
        super(key: key);

  final PushPressure _pushPressure;
  final BrewMethod _brewMethod;
  final List<Notes> _notes;

  static const double _methodPadding = 15;

  String _pushPressureText(PushPressure action) {
    switch (action) {
      case PushPressure.weak:
        return "Weak";
      case PushPressure.medium:
        return "Medium";
      case PushPressure.strong:
        return "Strong";

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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      padding: const EdgeInsets.only(
        top: 5,
        bottom: _methodPadding,
        left: _methodPadding,
        right: _methodPadding,
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
                // subtitle color with higher opacity
                color: Color.fromRGBO(217, 204, 191, 0.75),
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
                _buildRecipeMethodDescription(
                  description: "Push Pressure",
                  data: _pushPressureText(_pushPressure),
                ),
                const VerticalDivider(
                  color: kDarkSubtitleColor,
                  thickness: 1,
                  indent: 6,
                  endIndent: 6,
                ),
                _buildRecipeMethodDescription(
                  description: "Brew Method  ",
                  data: _brewMethodText(_brewMethod),
                ),
              ],
            ),
          ),
          const Divider(
            color: Color(0x00000000),
            height: _methodPadding,
          ),
          ListView.separated(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: _notes.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildRecipeNotes(index);
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

  Container _buildRecipeNotes(int index) {
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
              _notes[index].time,
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
                _notes[index].note,
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

  Column _buildRecipeMethodDescription({description, data}) {
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
