import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vsongbook/utils/constants.dart';
import 'package:vsongbook/helpers/app_settings.dart';
import 'package:vsongbook/screens/song_books.dart';
import 'package:vsongbook/screens/about_app.dart';
import 'package:vsongbook/screens/donate.dart';
import 'package:vsongbook/screens/help_desk.dart';
import 'package:vsongbook/screens/preferences.dart';

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
            leading: Icon(settings.isDarkMode ? Icons.brightness_4 : Icons.brightness_7),
            title: Text(LangStrings.darkMode),
            trailing: Switch(
              onChanged: (bool value) => settings.setDarkMode(value),
              value: settings.isDarkMode,
            ),
          );
        }),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text(LangStrings.manageApp),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Preferences();
              })
            );
          }
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.build),
          title: Text(LangStrings.manageSongbooks),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return SongBooks();
             })
            );
          }
        ),
        ListTile(
          leading: Icon(Icons.card_membership),
          title: Text(LangStrings.supportUs),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Donate();
             })
            );
          }
        ),
        Divider(),        
        ListTile(
          leading: Icon(Icons.help),
          title: Text(LangStrings.helpFeedback),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return HelpDesk();
             })
            );
          }
        ),
        ListTile(
          leading: Icon(Icons.info),
          title: Text(LangStrings.aboutTheApp + LangStrings.appName),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return AboutApp();
             })
            );
          }
        ),
      ],
    );
  }

  Widget drawerHeader() {
    return UserAccountsDrawerHeader(
      accountName: Text(LangStrings.appName + LangStrings.appVersion),
      accountEmail: Text(LangStrings.appSlogan),
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
