import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vsongbook/screens/books_load.dart';
import 'package:vsongbook/screens/songs_load.dart';
import 'package:vsongbook/screens/home_view.dart';
import 'package:vsongbook/utils/preferences.dart';

class AppStart extends StatefulWidget {
  AppStart();

  @override
  createState() => new AppStartState();
}

class AppStartState extends State<AppStart> {
  final globalKey = new GlobalKey<ScaffoldState>();

  AppStartState();

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

      if (this.mounted) {
      setState(() {
        if (booksLoaded != null && booksLoaded)
          {
            if (songsLoaded != null && songsLoaded)
            {
              Navigator.pushReplacement( context, new MaterialPageRoute(builder: (context) => new HomeView()));
            }
            else {
              Navigator.pushReplacement( context, new MaterialPageRoute(builder: (context) => new SongsLoad())); 
            }
          }
          else {
            Navigator.pushReplacement( context, new MaterialPageRoute(builder: (context) => new BooksLoad()));
          }
      });
    }
  }

}
