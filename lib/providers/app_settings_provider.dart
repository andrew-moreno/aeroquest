import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsProvider extends ChangeNotifier {
  /// Name of the grind interval setting in the Shared Preferences db
  ///
  /// Stores grind interval setting as int
  static const grindIntervalPref = "grindInterval";

  /// Name of the temperature system setting in the Shared Preferences db
  ///
  /// Stores the temperature system setting as a string representation of
  /// [TemperatureUnit]
  static const temperatureUnitPref = "temperatureUnit";

  /// Name of the water amount unit setting in the Shared Preferences db
  ///
  /// Stores the water amount unit settings as a string representation of [WaterUnit]
  static const waterUnitPref = "waterUnit";

  /// Name of the coffee amount unit setting in the Shared Preferences db
  ///
  /// Stores the coffee amount unit settings as a string representation of
  /// [CoffeeUnit]
  static const coffeeUnitPref = "coffeeUnit";

  /// Name of the setting that determines whether to display the onboarding
  /// screen when the app is opened for the first time
  static const isOnboardingSeen = "isOnboardingSeen";

  /// Temporary grind interval value
  ///
  /// Value set by [setGrindInterval()]
  ///
  /// Used instead of directly pulling from the Shared Preferences db to avoid
  /// async operations
  double? grindInterval;

  /// Temporary grind interval value that is used to select a value in the
  /// modal sheet without saving to the Shared Preferences db
  double? tempGrindInterval;

  /// Temporary temperature measurement system value
  ///
  /// Value set by [setTemperatureUnit()]
  ///
  /// Used instead of directly pulling from the Shared Preferences db to avoid
  /// async operations
  TemperatureUnit? temperatureUnit;

  /// Temporary temperature unit value that is used to select a value in the
  /// modal sheet without saving to the Shared Preferences db
  TemperatureUnit? tempTemperatureUnit;

  /// Temporary measurement system value for water amount
  ///
  /// Value set by [setWaterUnit()]
  ///
  /// Used instead of directly pulling from the Shared Preferences db to avoid
  /// async operations
  WaterUnit? waterUnit;

  /// Temporary water unit value that is used to select a value in the
  /// modal sheet without saving to the Shared Preferences db
  WaterUnit? tempWaterUnit;

  /// Temporary measurement system value for coffee amount
  ///
  /// Value set by [setCoffeeUnit()]
  ///
  /// Used instead of directly pulling from the Shared Preferences db to avoid
  /// async operations
  CoffeeUnit? coffeeUnit;

  /// Temporary coffee unit value that is used to select a value in the
  /// modal sheet without saving to the Shared Preferences db
  CoffeeUnit? tempCoffeeUnit;

  /// Populates [grindInterval], [temperatureUnit], [waterUnit], and
  /// [coffeeUnit] with data from their respective databases
  Future<void> cacheAppSettingData() async {
    await setGrindInterval();
    await setTemperatureUnit();
    await setWaterUnit();
    await setCoffeeUnit();
  }

  /// Sets [value] as the grind interval in the Shared Preferences db and sets
  /// [grindInterval] to the new value
  void updateGrindInterval(double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(grindIntervalPref, value);
    await setGrindInterval();
    notifyListeners();
  }

  /// Gets the grind interval from the Shared Preferences db
  ///
  /// If no value is set, returns 1 as the default value
  Future<double> getGrindInterval() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(grindIntervalPref) ?? 1;
  }

  /// Sets [grindInterval] to the current grind interval in the Shared
  /// Preferences db
  Future<void> setGrindInterval() async {
    grindInterval = await getGrindInterval();
  }

  /// Returns [number] as a String based on how many decimal places the value
  /// contains
  ///
  /// Used to concatenate repeating decimal values
  static String getGrindIntervalText(var number) {
    /// Get number of fraction digits from [number]
    int decimals = 0;
    List<String> substr = number.toString().split('.');
    if (substr.isNotEmpty) decimals = int.tryParse(substr[1])!;

    /// Determine output
    if (decimals > 2) {
      return number.toStringAsFixed(2);
    }
    return number.toString();
  }

  /// Sets [value] as the temperature unit in the Shared Preferences db and
  /// sets [temperatureUnit] to the new value
  Future<void> updateTemperatureUnit(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(temperatureUnitPref, value);
    await setTemperatureUnit();
    notifyListeners();
  }

  /// Gets the temperature unit from the Shared Preferences db
  ///
  /// If no value is set, returns "celsius" as the default value
  Future<String> getTemperatureUnit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(temperatureUnitPref) ??
        describeEnum(TemperatureUnit.celsius);
  }

  /// Sets [temperatureUnit] to the current temperature unit in the Shared
  /// Preferences db
  Future<void> setTemperatureUnit() async {
    if (await getTemperatureUnit() == describeEnum(TemperatureUnit.celsius)) {
      temperatureUnit = TemperatureUnit.celsius;
    } else {
      temperatureUnit = TemperatureUnit.fahrenheit;
    }
  }

  /// Sets [value] as the water amount unit in the Shared Preferences db and
  /// sets [waterUnit] to the new value
  Future<void> updateWaterUnit(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(waterUnitPref, value);
    await setWaterUnit();
    notifyListeners();
  }

  /// Gets the water amount unit from the Shared Preferences db
  ///
  /// If no value is set, returns "g" (grams) as the default value
  Future<String> getWaterUnit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(waterUnitPref) ?? describeEnum(WaterUnit.gram);
  }

  /// Sets [waterUnit] to the current water amount unit in the Shared
  /// Preferences db
  Future<void> setWaterUnit() async {
    if (await getWaterUnit() == describeEnum(WaterUnit.gram)) {
      waterUnit = WaterUnit.gram;
    } else {
      waterUnit = WaterUnit.ounce;
    }
  }

  /// Sets [value] as the coffee amount unit in the Shared Preferences db and
  /// sets [coffeeUnit] to the new value
  Future<void> updateCoffeeUnit(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(coffeeUnitPref, value);
    await setCoffeeUnit();
    notifyListeners();
  }

  /// Gets the coffee amount unit from the Shared Preferences db
  ///
  /// If no value is set, returns "g" (grams) as the default value
  Future<String> getCoffeeUnit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(coffeeUnitPref) ?? describeEnum(CoffeeUnit.gram);
  }

  /// Sets the current coffee amount unit in the Shared Preferences db to
  /// [coffeeUnit]
  Future<void> setCoffeeUnit() async {
    if (await getCoffeeUnit() == describeEnum(CoffeeUnit.gram)) {
      coffeeUnit = CoffeeUnit.gram;
    } else if (await getCoffeeUnit() == describeEnum(CoffeeUnit.tbps)) {
      coffeeUnit = CoffeeUnit.tbps;
    } else {
      coffeeUnit = CoffeeUnit.scoop;
    }
  }
}

enum TemperatureUnit { celsius, fahrenheit }

enum WaterUnit { gram, ounce }

enum CoffeeUnit { gram, tbps, scoop }
