import 'dart:async';
import 'dart:convert';

import 'package:vsongbook/models/callbacks/User.dart';
import 'package:vsongbook/utils/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    prefs.setString(SharedPreferenceKeys.User_Country_Name, country);
    prefs.setString(SharedPreferenceKeys.User_Country_Icode, icode);
    prefs.setString(SharedPreferenceKeys.User_Country_Ccode, ccode);
    prefs.setString(SharedPreferenceKeys.User_Mobile, mobile);
  }

  static Future<bool> isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(SharedPreferenceKeys.Is_User_Loggedin);
  }

  static Future<void> setUserLoggedIn(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(SharedPreferenceKeys.Is_User_Loggedin, isLoggedIn);
  }

  static Future<String> getSharedPreferenceStr(String prefKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(prefKey);
  }

  static Future<User> getUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return User.fromJson(
        json.decode(prefs.getString(SharedPreferenceKeys.User)));
  }

  static Future<void> setUserProfile(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userProfileJson = json.encode(user);
    return prefs.setString(SharedPreferenceKeys.User, userProfileJson);
  }

  static Future<bool> areAppBooksLoaded() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(SharedPreferenceKeys.App_Books_Loaded);
  }

  static Future<void> setBooksLoaded(bool areBooksLoaded) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(SharedPreferenceKeys.App_Books_Loaded, areBooksLoaded);
  }

  static Future<void> setSelectedBooks(String books) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(SharedPreferenceKeys.Selected_Books, books);
  }

  static Future<bool> areAppSongsLoaded() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(SharedPreferenceKeys.App_Songs_Loaded);
  }

  static Future<void> setSongsLoaded(bool areSongsLoaded) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(SharedPreferenceKeys.App_Songs_Loaded, areSongsLoaded);
  }
}
