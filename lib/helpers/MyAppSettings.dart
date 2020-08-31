import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vsongbook/utils/Constants.dart';

class MyAppSettings extends ChangeNotifier {
  /*static final _kRoutenameToRouteMap = {
    for (MyRoute route in kAllRoutes) route.routeName: route
  };*/

  final SharedPreferences _pref;

  MyAppSettings(this._pref);

  bool get isDarkMode => _pref?.getBool(SharedPreferenceKeys.DarkMode) ?? false;

  void setDarkMode(bool val) {
    _pref?.setBool(SharedPreferenceKeys.DarkMode, val);
    notifyListeners();
  }

}
