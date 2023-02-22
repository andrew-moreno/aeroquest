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

  /// Name of the temperature system setting in the Shared Preferences db
  ///
  /// Stores the mass system settings as a string representation of [MassUnit]
  static const massUnitPref = "massUnit";

  /// Temporary grind interval value
  ///
  /// Value set by [setGrindInterval()]
  ///
  /// Used instead of directly pulling from the Shared Preferences db to avoid
  /// async operations
  double? grindInterval;

  /// Temporary temperature measurement system value
  ///
  /// Value set by [setUnitSystem()]
  ///
  /// Used instead of directly pulling from the Shared Preferences db to avoid
  /// async operations
  TemperatureUnit? temperatureUnit;

  /// Temporary mass measurement system value
  ///
  /// Value set by [setUnitSystem()]
  ///
  /// Used instead of directly pulling from the Shared Preferences db to avoid
  /// async operations
  MassUnit? massUnit;

  /// Populates [grinInterval], [temperatureUnit] and [massUnit] with data
  /// from their respective databases
  Future<void> cacheAppSettingData() async {
    await setGrindInterval();
    await setTemperatureUnit();
    await setMassUnit();
  }

  /// Sets [value] as the grind interval in the Shared Preferences db and sets
  /// the new value to [grindInterval]
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

  /// Sets the current grind interval in the Shared Preferences db to
  /// [grindInterval]
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
  /// sets the new value to [temperatureUnit]
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

  /// Sets the current temperature unit in the Shared Preferences db to
  /// [temperatureUnit]
  Future<void> setTemperatureUnit() async {
    if (await getTemperatureUnit() == describeEnum(TemperatureUnit.celsius)) {
      temperatureUnit = TemperatureUnit.celsius;
    } else {
      temperatureUnit = TemperatureUnit.fahrenheit;
    }
  }

  /// Sets [value] as the mass unit in the Shared Preferences db and sets the
  /// new value to [massUnit]
  Future<void> updateMassUnit(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(massUnitPref, value);
    await setMassUnit();
    notifyListeners();
  }

  /// Gets the mass unit from the Shared Preferences db
  ///
  /// If no value is set, returns "g" as the default value
  Future<String> getMassUnit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(massUnitPref) ?? describeEnum(MassUnit.gram);
  }

  /// Sets the current temperature unit in the Shared Preferences db to
  /// [massUnit]
  Future<void> setMassUnit() async {
    if (await getMassUnit() == describeEnum(MassUnit.gram)) {
      massUnit = MassUnit.gram;
    } else {
      massUnit = MassUnit.ounce;
    }
  }
}

enum TemperatureUnit { celsius, fahrenheit }

enum MassUnit { gram, ounce }
