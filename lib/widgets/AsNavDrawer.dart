import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vsongbook/helpers/AppSettings.dart';
import 'package:vsongbook/screens/DdSongBooks.dart';
import 'package:vsongbook/screens/GgAboutApp.dart';
import 'package:vsongbook/screens/GgDonate.dart';
import 'package:vsongbook/screens/GgHelpDesk.dart';

class AsNavDrawer extends StatefulWidget {
  @override
  createState() => new AsNavDrawerState();
}

class AsNavDrawerState extends State<AsNavDrawer> {
  final globalKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    didChangeDependencies();

    return new ListView(
      children: <Widget>[
        drawerHeader(),
        Consumer<AppSettings>(builder: (context, AppSettings settings, _) {
          return ListTile(
            onTap: () {},
            leading: Icon(
                settings.isDarkMode ? Icons.brightness_4 : Icons.brightness_7),
            title: Text('Dark Mode'),
            trailing: Switch(
              onChanged: (bool value) => settings.setDarkMode(value),
              value: settings.isDarkMode,
            ),
          );
        }),
        Divider(),
        ListTile(
            leading: Icon(Icons.build),
            title: Text('Manage Songbooks'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return DdSongBooks();
              }));
            }),
        ListTile(
            leading: Icon(Icons.card_membership),
            title: Text('Support us'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return GgDonate();
              }));
            }),
        Divider(),
        /*ListTile(
          leading: Icon(Icons.settings),
          title: Text('App Settings'),
          //onTap: () => Navigator.pushReplacement( context, new MaterialPageRoute(builder: (context) => new XBasicScreen()))
        ),
        ListTile(leading: Icon(Icons.update), title: Text('App Updates')),*/
        ListTile(
            leading: Icon(Icons.help),
            title: Text('Help & Feedback'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return GgHelpDesk();
              }));
            }),
        ListTile(
            leading: Icon(Icons.info),
            title: Text('About vSongBook'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return GgAboutApp();
              }));
            }),
      ],
    );
  }

  Widget drawerHeader() {
    return UserAccountsDrawerHeader(
      accountName: Text('vSongBook v1.7.0'),
      accountEmail: Text("Freedom to sing anywhere"),
      currentAccountPicture: CircleAvatar(
        child: new Image(
          image: new AssetImage("assets/images/appicon.png"),
          height: 75,
          width: 75,
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
