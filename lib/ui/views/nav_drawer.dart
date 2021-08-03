import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/app_utils.dart';
import '../../services/app_settings.dart';
import '../pages/lists/song_books.dart';
import '../pages/info/about_app.dart';
import '../pages/info/donate.dart';
import '../pages/info/help_desk.dart';
import '../pages/preferences.dart';

class NavDrawer extends StatefulWidget {
  @override
  createState() => NavDrawerState();
}

class NavDrawerState extends State<NavDrawer> {
  final globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    didChangeDependencies();

    return ListView(
      children: <Widget>[
        drawerHeader(),
        Consumer<AppSettings>(builder: (context, AppSettings settings, _) {
          return ListTile(
            onTap: () {},
            leading: Icon(
                settings.isDarkMode ? Icons.brightness_4 : Icons.brightness_7),
            title: Text(AppStrings.darkMode),
            trailing: Switch(
              onChanged: (bool value) => settings.setDarkMode(value),
              value: settings.isDarkMode,
            ),
          );
        }),
        ListTile(
            leading: Icon(Icons.settings),
            title: Text(AppStrings.manageApp),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Preferences();
              }));
            }),
        Divider(),
        ListTile(
            leading: Icon(Icons.build),
            title: Text(AppStrings.manageSongbooks),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SongBooks();
              }));
            }),
        ListTile(
            leading: Icon(Icons.card_membership),
            title: Text(AppStrings.supportUs),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Donate();
              }));
            }),
        Divider(),
        ListTile(
            leading: Icon(Icons.help),
            title: Text(AppStrings.helpFeedback),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return HelpDesk();
              }));
            }),
        ListTile(
            leading: Icon(Icons.info),
            title: Text(AppStrings.aboutTheApp + AppStrings.appName),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return AboutApp();
              }));
            }),
      ],
    );
  }

  Widget drawerHeader() {
    return UserAccountsDrawerHeader(
      accountName: Text(AppStrings.appName + AppStrings.appVersion),
      accountEmail: Text(AppStrings.appSlogan),
      currentAccountPicture: CircleAvatar(
        child: Image(
          image: AssetImage("assets/images/appicon.png"),
          height: 75,
          width: 75,
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
