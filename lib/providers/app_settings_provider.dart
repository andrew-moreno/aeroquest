import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsProvider extends ChangeNotifier {
  /// Name of the grind interval setting in the Shared Preferences db
  static const grindIntervalPref = "grindInterval";

  /// Name of the temperature unit setting in the Shared Preferences db
  static const temperatureUnitPref = "temperatureUnitPref";

  /// Temporary grind interval value
  ///
  /// Value set by [setGrindInterval()]
  ///
  /// Used instead of directly pulling from the Shared Preferences db to avoid
  /// async operations
  double? grindInterval;

  /// Temporary temperature unit value
  ///
  /// Value set by [setTemperatureUnit()]
  ///
  /// Used instead of directly pulling from the Shared Preferences db to avoid
  /// async operations
  TemperatureUnit? temperatureUnit;

  /// Sets [value] as the grind interval in the Shared Preferences db and sets
  /// the new value to [grindInterval]
  void updateGrindInterval(double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(grindIntervalPref, value);
    setGrindInterval();
    notifyListeners();
  }

  /// Gets the grind interval from the Shared Preferences db
  Future<double> getGrindInterval() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(grindIntervalPref) ?? 1;
  }

  /// Sets the current grind interval in the Shared Preferences db to
  /// [grindInterval]
  Future<void> setGrindInterval() async {
    grindInterval = await getGrindInterval();
  }

  void updateTemperatureUnit(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(temperatureUnitPref, value);
    setTemperatureUnit();
    notifyListeners();
  }

  Future<String> getTemperatureUnit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(temperatureUnitPref) ??
        describeEnum(TemperatureUnit.celsius);
  }

  Future<void> setTemperatureUnit() async {
    if (await getTemperatureUnit() == describeEnum(TemperatureUnit.celsius)) {
      temperatureUnit = TemperatureUnit.celsius;
    } else {
      temperatureUnit = TemperatureUnit.fahrenheit;
    }
  }
}

enum TemperatureUnit { celsius, fahrenheit }
