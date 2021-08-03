import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:firebase_analytics/firebase_analytics.dart';
//import 'package:firebase_analytics/observer.dart';

import 'utils/app_utils.dart';
import 'utils/themes.dart';
import 'services/app_settings.dart';
import 'ui/pages/app_splash.dart';
import 'ui/pages/app_start.dart';

void main() {
  runApp(MyApplication());
}

class MyApplication extends StatelessWidget {
  const MyApplication({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder:
          (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
        if (!snapshot.hasData) {
          return AppSplash();
        }
        return ChangeNotifierProvider<AppSettings>.value(
          value: AppSettings(snapshot.data),
          child: _MyApplication(),
        );
      },
    );
  }
}

class _MyApplication extends StatelessWidget {
  //final FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      //debugShowCheckedModeBanner: false,
      theme: Provider.of<AppSettings>(context).isDarkMode
          ? asDarkTheme
          : asLightTheme,
      home: AppStart(),
      navigatorObservers: [
        //FirebaseAnalyticsObserver(analytics: analytics),
      ],
    );
  }
}
