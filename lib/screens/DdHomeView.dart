import 'package:flutter/material.dart';
import 'package:vsongbook/views/AsFavorites.dart';
import 'package:vsongbook/views/AsSearchSongs.dart';
import 'package:vsongbook/views/AsSongPad.dart';
import 'package:vsongbook/widgets/AsNavDrawer.dart';

class DdHomeView extends StatefulWidget {
  final String bookstr;

  DdHomeView(this.bookstr);

  @override
  State<StatefulWidget> createState() {
    return DdHomeViewState(this.bookstr);
  }
}

class DdHomeViewState extends State<DdHomeView> {
  DdHomeViewState(this.bookstr);

  final globalKey = new GlobalKey<ScaffoldState>();
  AsSongPad drafts = AsSongPad();
  AsNavDrawer navDrawer;
  String bookstr;

  @override
  Widget build(BuildContext context) {
    var books = this.bookstr.split(",");
    AsSearchSongs home = AsSearchSongs.getList(int.parse(books[0]));
    AsFavorites likes = AsFavorites();

    final appPages = <Widget>[
      Center(child: home),
      Center(child: likes),
      Center(child: drafts),
      //Center(child: Container()),
    ];

    final appTabs = <Tab>[
      Tab(text: 'HOME'),
      Tab(text: 'LIKES'),
      Tab(text: 'DRAFTS'),
      //Tab(text: 'SERMONPAD')
    ];

    if (navDrawer == null) navDrawer = AsNavDrawer();
    return DefaultTabController(
      length: appTabs.length,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('vSongBook'),
          bottom: TabBar(tabs: appTabs),
        ),
        body: TabBarView(children: appPages),
        drawer: Drawer(child: navDrawer),
      ),
    );
  }
}
