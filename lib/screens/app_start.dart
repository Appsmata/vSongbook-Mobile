import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vsongbook/screens/cc_books_load.dart';
import 'package:vsongbook/screens/cc_songs_load.dart';
import 'package:vsongbook/screens/dd_home_view.dart';
import 'package:vsongbook/utils/constants.dart';
import 'package:vsongbook/utils/preferences.dart';

class AppStart extends StatefulWidget {
  @override
  createState() => new SplashPageState();
}

class SplashPageState extends State<AppStart> {
  final globalKey = new GlobalKey<ScaffoldState>();

@override
  Widget build(BuildContext context) {
    new Future.delayed(const Duration(seconds: 3), _handleTapEvent);
    return MaterialApp(
      home: Scaffold(
      body: Center( 
        child: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: new AssetImage("assets/images/splash.jpg"),
              fit: BoxFit.cover
            )
          ),
          )
        )
      )
    ); 
  }

  void _handleTapEvent() async {
    bool booksLoaded = await Preferences.areAppBooksLoaded();
    bool songsLoaded = await Preferences.areAppSongsLoaded();
    String books = await Preferences.getSharedPreferenceStr(SharedPreferenceKeys.Selected_Books);

      if (this.mounted) {
      setState(() {
        if (booksLoaded != null && booksLoaded)
          {
            if (songsLoaded != null && songsLoaded)
            {
              Navigator.pushReplacement( context, new MaterialPageRoute(builder: (context) => new DdHomeView(books)));
              //Navigator.pushReplacement( context, new MaterialPageRoute(builder: (context) => new DdHomeView())); 
            }
            else {
              Navigator.pushReplacement( context, new MaterialPageRoute(builder: (context) => new CcSongsLoad())); 
            }
          }
          else {
            Navigator.pushReplacement( context, new MaterialPageRoute(builder: (context) => new CcBooksLoad()));
          }
      });
    }
  }

}
