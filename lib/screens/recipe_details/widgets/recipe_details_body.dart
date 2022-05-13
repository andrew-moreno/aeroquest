import 'package:aeroquest/models/recipe_entry.dart';
import 'package:aeroquest/widgets/recipe_settings/widgets/bean_settings.dart';
import 'package:flutter/material.dart';
import 'package:aeroquest/constraints.dart';

class RecipeDetailsBody extends StatefulWidget {
  const RecipeDetailsBody({
    Key? key,
    required recipeData,
  })  : _recipeData = recipeData,
        super(key: key);

  final RecipeEntry _recipeData;

  @override
  State<RecipeDetailsBody> createState() => _RecipeDetailsBodyState();
}

class _RecipeDetailsBodyState extends State<RecipeDetailsBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 35, right: 35, bottom: 20),
      child: Column(
        children: [
          Text(
            "Bean Settings",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline4,
          ),
          const Divider(
            height: 15,
            color: Color(0x00000000),
          ),
          BeanSettingsGroup(
            recipeData: widget._recipeData,
          ),
          const Divider(
            height: 30,
            color: Color(0x00000000),
          ),
          Text(
            "Method",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline4,
          ),
          const Divider(
            height: 15,
            color: Color(0x00000000),
          ),
          RecipeMethod(
            pushPressure: widget._recipeData.pushPressure,
            brewMethod: widget._recipeData.brewMethod,
            notes: widget._recipeData.notes,
          ),
        ],
      ),
    );
  }
}

class BeanSettingsGroup extends StatelessWidget {
  const BeanSettingsGroup({
    Key? key,
    required recipeData,
  })  : _recipeData = recipeData,
        super(key: key);

  final RecipeEntry _recipeData;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: _recipeData.coffeeSettings.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return BeanSettings(
          coffeeSetting: _recipeData.coffeeSettings[index],
        );
      },
      separatorBuilder: (context, index) {
        return const Divider(
          color: Color(0x00000000),
          height: 10,
        );
      },
    );
  }
}

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
              _buildRecipeMethodDescription(
                description: "Push Pressure",
                data: _pushPressureText(_pushPressure),
              ),
              const VerticalDivider(
                color: Color(0x00000000),
                thickness: 10,
              ),
              _buildRecipeMethodDescription(
                description: "Brew Method  ",
                data: _brewMethodText(_brewMethod),
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
              _notes[index].time,
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
                _notes[index].note,
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

  // template for push pressure and brew method text
  Column _buildRecipeMethodDescription({description, data}) {
    return Column(
      children: [
        Text(
          description,
          style: const TextStyle(
            color: kSubtitle,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        Text(
          data,
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
