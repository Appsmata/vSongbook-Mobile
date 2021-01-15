import 'package:flutter/material.dart';

import 'package:vsongbook/utils/colored_tabbar.dart';
import 'package:vsongbook/utils/constants.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

class AboutApp extends StatefulWidget {
  @override
  createState() => AboutAppState();
}

class AboutAppState extends State<AboutApp> {
  final globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final _Titles = <Tab>[
      Tab(text: 'ABOUT'),
      Tab(text: 'HISTORY'),
      Tab(text: 'APPRECIATION'),
    ];

    final _Tabs = <Widget>[
      Container(
          margin: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
          child: ListView(
            children: <Widget>[
              Html(
                data: LangStrings.appAbout,
                style: {
                  "h3": Style(fontSize: FontSize(30.0)),
                  "p": Style(fontSize: FontSize(20.0)),
                },
              )
            ],
          )),
      Container(
        margin: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
        child: ListView(
          children: <Widget>[
            Html(
              data: LangStrings.appHistory,
              style: {
                "h3": Style(fontSize: FontSize(30.0)),
                "p": Style(fontSize: FontSize(20.0)),
              },
            )
          ],
        ),
      ),
      Container(
          margin: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
          child: ListView(
            children: <Widget>[
              Html(
                data: LangStrings.appThanks,
                style: {
                  "h3": Style(fontSize: FontSize(30.0)),
                  "p": Style(fontSize: FontSize(20.0)),
                },
              )
            ],
          )),
    ];

    return WillPopScope(
      onWillPop: () {
        moveToLastScreen();
      },
      child:  DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(LangStrings.aboutTheApp + LangStrings.appName),
            bottom: TabBar(
              tabs: _Titles,
            ),
          ),
          body: TabBarView(
            children: _Tabs,
          ),
        ),
      ),
    );
  }

  /// Go back to the screen before the current one
  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}
