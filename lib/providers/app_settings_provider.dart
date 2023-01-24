import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsProvider extends ChangeNotifier {
  /// Name of the grind interval setting in the Shared Preferences db
  static const grindIntervalPref = "grindInterval";

  /// Temporary grind interval value
  ///
  /// Value set by [setGrindInterval()]
  ///
  /// Used instead of directly pulling from [SharedPreferences] to avoid
  /// async operations
  double? grindInterval;

  /// Sets [value] as the grind interval in the Shared Preferences db and sets
  /// the new value to [grindInterval]
  updateGrindInterval(double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(grindIntervalPref, value);
    setGrindInterval();
    notifyListeners();
  }

  /// Gets the grind interval from the Shared Preferences db
  Future<double> getGrindInterval() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return double
    double doubleValue = prefs.getDouble(grindIntervalPref) ?? 1;
    return doubleValue;
  }

  /// Sets the current grind interval in the Shared Preferences db to
  /// [grindInterval]
  Future<void> setGrindInterval() async {
    grindInterval = await getGrindInterval();
  }
}
