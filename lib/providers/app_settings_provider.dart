import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsProvider extends ChangeNotifier {
  /// Name of the grind interval setting in the Shared Preferences db
  static const grindIntervalPref = "grindInterval";

  /// Name of the measurement system in the Shared Preferences db
  static const unitsPref = "unitsPref";

  /// Temporary grind interval value
  ///
  /// Value set by [setGrindInterval()]
  ///
  /// Used instead of directly pulling from the Shared Preferences db to avoid
  /// async operations
  double? grindInterval;

  /// Temporary unit system value
  ///
  /// Value set by [setUnitSystem()]
  ///
  /// Used instead of directly pulling from the Shared Preferences db to avoid
  /// async operations
  UnitSystem? unitSystem;

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

  void updateUnitSystem(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(unitsPref, value);
    setUnitSystem();
    notifyListeners();
  }

  Future<String> getUnitSystem() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(unitsPref) ?? describeEnum(UnitSystem.metric);
  }

  Future<void> setUnitSystem() async {
    if (await getUnitSystem() == describeEnum(UnitSystem.metric)) {
      unitSystem = UnitSystem.metric;
    } else {
      unitSystem = UnitSystem.imperial;
    }
  }
}

enum UnitSystem { metric, imperial }
