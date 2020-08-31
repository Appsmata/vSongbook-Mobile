import 'package:flutter/material.dart';
import 'package:vsongbook/screens/DdSongBooks.dart';

class AsNavDrawerGuest extends StatefulWidget {

  @override
  createState() => new AsNavDrawerGuestState();

}

class AsNavDrawerGuestState extends State<AsNavDrawerGuest> {
  final globalKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    didChangeDependencies();
    
    return new ListView(
      children: <Widget>[
        drawerHeader(),
        ListTile(
          leading: Icon(Icons.build),
          title: Text('Manage Songbooks'),
          onTap: () {
            Navigator.pushReplacement( 
              context, new MaterialPageRoute(builder: (context) => new DdSongBooks()
            ));
          }
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
      accountName: Text('vSongBook v1.5.0'),
      accountEmail: Text("Freedom to sing anywhere"),
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


}
