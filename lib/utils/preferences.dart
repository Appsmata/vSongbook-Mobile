import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/callbacks/User.dart';
import 'app_utils.dart';

class Preferences {
  static Future<SharedPreferences> getInstance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  static Future<void> clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  static Future<void> setCountryPhone(
      String country, String icode, String ccode, String mobile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(SharedPreferenceKeys.userCountryName, country);
    prefs.setString(SharedPreferenceKeys.userCountryIcode, icode);
    prefs.setString(SharedPreferenceKeys.userCountryCcode, ccode);
    prefs.setString(SharedPreferenceKeys.userMobile, mobile);
  }

  static Future<bool> isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(SharedPreferenceKeys.isUserLoggedin);
  }

  static Future<void> setUserLoggedIn(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(SharedPreferenceKeys.isUserLoggedin, isLoggedIn);
  }

  static Future<String> getSharedPreferenceStr(String prefKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(prefKey);
  }

  static Future<User> getUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return User.fromJson(
        json.decode(prefs.getString(SharedPreferenceKeys.user)));
  }

  static Future<void> setUserProfile(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userProfileJson = json.encode(user);
    return prefs.setString(SharedPreferenceKeys.user, userProfileJson);
  }

  static Future<bool> areAppBooksLoaded() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(SharedPreferenceKeys.appBooksLoaded);
  }

  static Future<void> setBooksLoaded(bool areBooksLoaded) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(SharedPreferenceKeys.appBooksLoaded, areBooksLoaded);
  }

  static Future<void> setSelectedBooks(String books) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(SharedPreferenceKeys.selectedBooks, books);
  }

  static Future<bool> areAppSongsLoaded() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(SharedPreferenceKeys.appSongsLoaded);
  }

  static Future<void> setSongsLoaded(bool areSongsLoaded) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(SharedPreferenceKeys.appSongsLoaded, areSongsLoaded);
  }
}
