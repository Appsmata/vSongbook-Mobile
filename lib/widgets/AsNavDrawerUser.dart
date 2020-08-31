import 'package:flutter/material.dart';
import 'package:vsongbook/models/callbacks/User.dart';
import 'package:vsongbook/screens/AppStart.dart';
import 'package:vsongbook/utils/Preferences.dart';

class AsNavDrawerUser extends StatefulWidget {

  @override
  createState() => new AsNavDrawerUserState();

}

class AsNavDrawerUserState extends State<AsNavDrawerUser> {
  final globalKey = new GlobalKey<ScaffoldState>();
  User user;

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    if (user == null) {
      await initUserProfile();
    }
  }

  Future<void> initUserProfile() async {
    User up = await Preferences.getUserProfile();
    setState(() {
      user = up;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      didChangeDependencies();
    }

    return new ListView(
      children: <Widget>[
        drawerHeader(),
        ListTile( 
          leading: Icon(Icons.account_circle),
          title: Text('My Updates'),
          //onTap: () => Navigator.of(context).push(_NewPage(1)),
        ),
        ListTile(
          leading: Icon(Icons.account_circle),
          title: Text('Logout'),
          onTap: () {
            showDialog(
                context: context,
                child: _logOutDialog());
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.build),
          title: Text('Manage Songbooks'),//onTap: () => Navigator.of(context).push(_NewPage(2)),
        ),
        ListTile(
          leading: Icon(Icons.card_membership),
          title: Text('Support us'),
          //onTap: () => Navigator.pushReplacement( context, new MaterialPageRoute(builder: (context) => new XBasicScreen()))
        ),
        Divider(),
        ListTile( 
          title: Text('App Settings'), 
          //onTap: () => Navigator.pushReplacement( context, new MaterialPageRoute(builder: (context) => new XBasicScreen()))
        ),
        ListTile( title: Text('App Updates') ),
        ListTile( title: Text('Help Feedback') ),
        ListTile( title: Text('About vSongBook') ),
      ],
    );
  }

  Widget drawerHeader() {
    return UserAccountsDrawerHeader(
      accountName: Text(
        user != null ? user.firstname + " " + user.lastname + " - " + user.country : "vSongBook"
      ),
      accountEmail: Text(user != null ? user.mobile + "" : ""),
      currentAccountPicture: CircleAvatar(
        child: new Image(
          image: new AssetImage("assets/images/appicon.png"),
          height: 50,
          width: 50,
        ),
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget _logOutDialog() {
    return new AlertDialog(
      title: new Text(
        "Logout",
        style: new TextStyle(color: Colors.orange, fontSize: 20),
      ),
      content: new Text(
        "Are you sure you want to Logout from the App?",
        style: new TextStyle(color: Colors.grey, fontSize: 20),
      ),
      actions: <Widget>[
        new FlatButton(
          child: new Text("OK",
              style: new TextStyle(color: Colors.orange, fontSize: 20)),
          onPressed: () {
            Preferences.clear();
            Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => new AppStart()));
          },
        ),
        new FlatButton(
          child: new Text("Cancel",
              style: new TextStyle(color: Colors.orange, fontSize: 20)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

}
