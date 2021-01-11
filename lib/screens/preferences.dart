import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:vsongbook/utils/colors.dart';
import 'package:vsongbook/utils/constants.dart';
import 'package:vsongbook/helpers/app_settings.dart';

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
          title: Text(LangStrings.appName + LangStrings.appSettings),
        ),
        body: ListView(
          children: <Widget>[
            settingOption1(),
            Divider(),
            settingOption2(),
            Divider(),
          ]
        ),
      ),
    );
  }

  Widget settingOption1()
  {
    return Consumer<AppSettings>(builder: (context, AppSettings settings, _) {
      return ListTile(
        leading: Icon(settings.isDarkMode ? Icons.brightness_4 : Icons.brightness_7),
        title: Text(LangStrings.appTheme),
        subtitle: Text((settings.isDarkMode ? LangStrings.darkMode : LangStrings.lightMode)),
        onTap: () { },
        trailing: Switch(
          onChanged: (bool value) => settings.setDarkMode(value),
          value: settings.isDarkMode,
        ),
      );
    });
  }

  Widget settingOption2()
  {
    return Consumer<AppSettings>(builder: (context, AppSettings settings, _) {
      return ListTile(
        onTap: () {},
        leading: Icon(Icons.settings_applications),
        title: Text(LangStrings.screenAwake),
        subtitle: Text((settings.isScreenAwake ? LangStrings.screenAwakeOn : LangStrings.screenAwakeOff)),
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
