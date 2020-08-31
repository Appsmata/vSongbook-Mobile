import 'package:flutter/material.dart';
import 'package:vsongbook/widgets/AsSearchSongs.dart';
import 'package:vsongbook/widgets/AsSongPad.dart';
import 'package:vsongbook/widgets/AsNavDrawerUser.dart';

class DdHomeView extends StatefulWidget {
  const DdHomeView({Key key}) : super(key: key);

  @override
  createState() => new DdHomeViewState();
}

class DdHomeViewState extends State<DdHomeView> {
  final globalKey = new GlobalKey<ScaffoldState>();
  AsSearchSongs searchSongs = AsSearchSongs();
  AsSongPad songPad = AsSongPad();
  AsNavDrawerUser navDrawer;
  
  @override
  Widget build(BuildContext context) {
    

    final vsbPages = <Widget>[
      Center(child: searchSongs),
      //Center(child: songPad),
      //Center(child: Container()),
    ];

    final vsbTabs = <Tab>[ 
      Tab(text: 'SONG SEARCH'), 
      //Tab(text: 'SONGPAD'),
      //Tab(text: 'SERMONPAD') 
    ];

    if (navDrawer == null) navDrawer = AsNavDrawerUser();
    return DefaultTabController(
      length: vsbTabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('vSongBook'),
          actions: <Widget>[
            IconButton( icon: Icon(Icons.search), onPressed: showSongsTab ),
            IconButton( icon: Icon(Icons.edit), onPressed: showDraftsTab ),
            IconButton( icon: Icon(Icons.speaker_notes), onPressed: showSermonsTab ),
          ],
          bottom: TabBar( tabs: vsbTabs ),
        ),
        body: TabBarView( children: vsbPages ),        
        drawer: Drawer( child: navDrawer ),
      ),
    );
  }

  void showSongsTab()
  {

  }

  void showDraftsTab()
  {

  }

  void showSermonsTab()
  {

  }

}
