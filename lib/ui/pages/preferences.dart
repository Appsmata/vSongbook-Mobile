import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/colors.dart';
import '../../utils/app_utils.dart';
import '../../services/app_settings.dart';

class Preferences extends StatefulWidget {
  @override
  createState() => PreferencesState();
}

class PreferencesState extends State<Preferences> {
  final globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        moveToLastScreen();
      },
      child: Scaffold(
        key: globalKey,
        appBar: AppBar(
          title: Text(AppStrings.appName + AppStrings.appSettings),
        ),
        body: ListView(children: <Widget>[
          settingOption1(),
          Divider(),
          settingOption2(),
          Divider(),
        ]),
      ),
    );
  }

  Widget settingOption1() {
    return Consumer<AppSettings>(builder: (context, AppSettings settings, _) {
      return ListTile(
        leading:
            Icon(settings.isDarkMode ? Icons.brightness_4 : Icons.brightness_7),
        title: Text(AppStrings.appTheme),
        subtitle: Text(
            (settings.isDarkMode ? AppStrings.darkMode : AppStrings.lightMode)),
        onTap: () {},
        trailing: Switch(
          onChanged: (bool value) => settings.setDarkMode(value),
          value: settings.isDarkMode,
        ),
      );
    });
  }

  Widget settingOption2() {
    return Consumer<AppSettings>(builder: (context, AppSettings settings, _) {
      return ListTile(
        onTap: () {},
        leading: Icon(Icons.settings_applications),
        title: Text(AppStrings.screenAwake),
        subtitle: Text((settings.isScreenAwake
            ? AppStrings.screenAwakeOn
            : AppStrings.screenAwakeOff)),
        trailing: Switch(
          onChanged: (bool value) => settings.setScreenAwake(value),
          value: settings.isScreenAwake,
        ),
      );
    });
  }

  /// Go back to the screen before the current one
  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}
