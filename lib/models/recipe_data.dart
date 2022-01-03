import 'recipe.dart';

class RecipeData {
  final List<Recipe> recipes = [
    Recipe(
      title: "The Hoffman Special",
      description: "Hot cup that serves one",
      coffee: [
        Coffee(
          name: "JJBean",
          grindSetting: 17,
          coffeeAmount: 11,
          waterAmount: 200,
          waterTemp: 100,
          brewTime: "2:30",
        ),
        Coffee(
          name: "Dark Xmas Gift from Parentals",
          grindSetting: 17,
          coffeeAmount: 12,
          waterAmount: 200,
          waterTemp: 86,
          brewTime: "2:30",
        ),
      ],
      pushPressure: PushPressure.weak,
      brewMethod: BrewMethod.regular,
      notes: [
        Notes(time: "2:30", note: "Lightly swirl to bring grounds to bottom"),
      ],
    ),
    Recipe(
      title: "StrongBoi 3000 That Is Just RichBoi",
      description:
          "Rich and full-bodied hot cup that serves one and is yum yum in my tum tum and im making this super long on purpose omg this is a long description",
      coffee: [
        Coffee(
          name: "JJBean",
          grindSetting: 16.5,
          coffeeAmount: 18,
          waterAmount: 260,
          waterTemp: 95,
          brewTime: "8:30",
        )
      ],
      pushPressure: PushPressure.weak,
      brewMethod: BrewMethod.inverted,
      notes: [
        Notes(
            time: "0:00",
            note: "Stir back and forth to wet all grounds in Aeropress"),
        Notes(
            time: "2:00", note: "Be like omg this about to be yum can't wait!"),
      ],
    ),
    Recipe(
      title: "The Hoffman Special",
      description: "Hot cup that serves one",
      coffee: [
        Coffee(
          name: "JJBean",
          grindSetting: 17,
          coffeeAmount: 11,
          waterAmount: 200,
          waterTemp: 100,
          brewTime: "2:30",
        ),
        Coffee(
          name: "Dark Xmas Gift from Parentals",
          grindSetting: 17,
          coffeeAmount: 12,
          waterAmount: 200,
          waterTemp: 86,
          brewTime: "2:30",
        ),
      ],
      pushPressure: PushPressure.weak,
      brewMethod: BrewMethod.regular,
      notes: [
        Notes(time: "2:30", note: "Lightly swirl to bring grounds to bottom"),
      ],
    ),
    Recipe(
      title: "The Hoffman Special",
      description: "Hot cup that serves one",
      coffee: [
        Coffee(
          name: "JJBean",
          grindSetting: 17,
          coffeeAmount: 11,
          waterAmount: 200,
          waterTemp: 100,
          brewTime: "2:30",
        ),
        Coffee(
          name:
              "Dark Xmas Gift from Parentals that is super yummy and this is gonna be long also wowee woo wawa omg omg omg i like coffee",
          grindSetting: 17,
          coffeeAmount: 12,
          waterAmount: 200,
          waterTemp: 86,
          brewTime: "2:30",
        ),
      ],
      pushPressure: PushPressure.weak,
      brewMethod: BrewMethod.regular,
      notes: [
        Notes(time: "2:30", note: "Lightly swirl to bring grounds to bottom"),
      ],
    ),
    Recipe(
      title: "The Hoffman Special",
      description: "Hot cup that serves one",
      coffee: [
        Coffee(
          name: "JJBean",
          grindSetting: 17,
          coffeeAmount: 11,
          waterAmount: 200,
          waterTemp: 100,
          brewTime: "2:30",
        ),
        Coffee(
          name: "Dark Xmas Gift from Parentals",
          grindSetting: 17,
          coffeeAmount: 12,
          waterAmount: 200,
          waterTemp: 86,
          brewTime: "2:30",
        ),
      ],
      pushPressure: PushPressure.weak,
      brewMethod: BrewMethod.regular,
      notes: [
        Notes(time: "2:30", note: "Lightly swirl to bring grounds to bottom"),
      ],
    ),
  ];
}
