import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vsongbook/utils/colors.dart';
import 'package:vsongbook/utils/constants.dart';
import 'package:vsongbook/views/as_favorites.dart';
import 'package:vsongbook/views/as_search_songs.dart';
import 'package:vsongbook/views/as_song_pad.dart';
import 'package:vsongbook/models/song_model.dart';
import 'package:vsongbook/helpers/sqlite_helper.dart';
import 'package:vsongbook/widgets/as_nav_drawer.dart';
import 'package:vsongbook/widgets/as_song_item.dart';

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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _lastIntegerSelected;
  AsNavDrawer navDrawer;
  String bookstr;

  SqliteHelper db = SqliteHelper();
  List<SongModel> songList;
	int count = 0;
	String query = '';

  void updateSongList() {
    final Future<Database> dbFuture = db.initializeDatabase();
    dbFuture.then((database) {
      Future<List<SongModel>> songListFuture = db.getSongList(0);
      songListFuture.then((songList) {
        setState(() {
          this.songList = songList;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (songList == null) {
      songList = List<SongModel>();
      updateSongList();
    }

    var books = this.bookstr.split(",");
    AsSearchSongs home = AsSearchSongs.getList(int.parse(books[0]));
    AsFavorites likes = AsFavorites();
    AsSongPad drafts = AsSongPad();
    
    final appPages = <Widget>[
      Center(child: home),
      Center(child: likes),
      Center(child: drafts),
    ];

    final appTabs = <Tab>[
      Tab(text: 'HOME'),
      Tab(text: 'LIKES'),
      Tab(text: 'DRAFTS'),
    ];

    if (navDrawer == null) navDrawer = AsNavDrawer();

    return DefaultTabController(
      length: appTabs.length,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          iconTheme: new IconThemeData(color: ColorUtils.white),
          title: const Text(LangStrings.appName),
          bottom: TabBar(tabs: appTabs),
          actions: <Widget>[
            IconButton(
              tooltip: LangStrings.SearchNow,
              icon: const Icon(Icons.search),
              onPressed: () async {
                final String selected = await showSearch(
                  context: context, 
                  delegate: SongSearchDelegate(songList)
                );
                if (selected != null && selected != query) {
                  setState(() {
                    query = selected;
                  });
                }
              },
            ),
            
            IconButton(
              icon: Icon(
                Theme.of(context).platform == TargetPlatform.iOS ? Icons.more_horiz : Icons.more_vert,
              ),
              onPressed: () { },
            ),
          ],
        ),
        body: TabBarView(children: appPages),
        drawer: Drawer(child: navDrawer),
      ),
    );
  }
}

class SongSearchDelegate extends SearchDelegate<String> {

  SqliteHelper db = SqliteHelper();
	List<SongModel> songList;

	SongSearchDelegate(this.songList);

	/*@override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
			primaryColor: Color(0xFFFFC078),
			accentIconTheme: IconThemeData(color: Colors.white),
			primaryIconTheme: IconThemeData(color: Colors.white),
			textTheme: TextTheme(
				title: TextStyle(
						color: Color(0xFFFBF5E8)
				),
			),
			primaryTextTheme: TextTheme(
				title: TextStyle(
					color: Color(0xFFFBF5E8)
				),
			),
		);
  }*/

  @override
  String get searchFieldLabel => LangStrings.SearchNow;

  @override
  List<Widget> buildActions(BuildContext context) {
		return <Widget>[
			IconButton(
				icon: const Icon((Icons.clear)),
				onPressed: () {
					query = '';
					showSuggestions(context);
				},
			)
		];
  }

  @override
  Widget buildLeading(BuildContext context) {
		return IconButton(
			icon: AnimatedIcon(icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
			onPressed: () {
				close(context, null);
			},
		);
  }

  @override
  Widget buildResults(BuildContext context) {
		Future<List<SongModel>> songListFuture = db.getSongSearch(query);
		songListFuture.then((songList) {
			this.songList = songList;
		});
		return ListView.builder(
      itemCount: songList.length,
      itemBuilder: (BuildContext context, int index) {
        return AsSongItem(songList[index]);
      }
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
		Future<List<SongModel>> songListFuture = db.getSongSearch(query);
		songListFuture.then((songList) {
				this.songList = songList;
		});
		return ListView.builder(
      itemCount: songList.length,
      itemBuilder: (BuildContext context, int index) {
        return AsSongItem(songList[index]);
      }
    );
  }
}
