import 'package:flutter/material.dart';
import 'package:backdrop/backdrop.dart';
import 'package:vsongbook/utils/ColoredTabBar.dart';
import 'package:vsongbook/utils/Constants.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

class GgAboutApp extends StatefulWidget {
  @override
  createState() => new GgAboutAppState();
}

class GgAboutAppState extends State<GgAboutApp> {
  final globalKey = new GlobalKey<ScaffoldState>();

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
                data: LangStrings.AppAbout,
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
              data: LangStrings.AppHistory,
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
                data: LangStrings.AppThanks,
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
      child: BackdropScaffold(
        title: Text('About vSongBook App'),
        iconPosition: BackdropIconPosition.action,
        headerHeight: 120,
        frontLayer: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: ColoredTabBar(
              color: Theme.of(context).primaryColor,
              tabBar: TabBar(tabs: _Titles),
            ),
            body: TabBarView(children: _Tabs),
          ),
        ),
      ),
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}
