import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vsongbook/screens/CcBooksLoad.dart';
import 'package:vsongbook/screens/CcSongsLoad.dart';
import 'package:vsongbook/screens/DdHomeView.dart';
import 'package:vsongbook/screens/BbUserSignin.dart';
import 'package:vsongbook/utils/Constants.dart';
import 'package:vsongbook/utils/Preferences.dart';

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
