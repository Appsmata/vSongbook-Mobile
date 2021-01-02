import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vsongbook/models/book_model.dart';
import 'package:vsongbook/models/song_model.dart';
import 'package:vsongbook/helpers/app_database.dart';
import 'package:vsongbook/screens/song_edit.dart';
import 'package:vsongbook/views/song_item.dart';
import 'package:vsongbook/widgets/as_loader.dart';
import 'package:vsongbook/widgets/as_notice.dart';
import 'package:vsongbook/utils/constants.dart';

class SongPad extends StatefulWidget {
	final List<BookModel> books;
  const SongPad(this.books);

  @override
  createState() => SongPadState();

}

class SongPadState extends State<SongPad> {
  AsNotice notice = AsNotice.getNotice(LangStrings.noDrafts);
  AsLoader loader = AsLoader();
  AppDatabase db = AppDatabase();

  SongPadState();
  Future<Database> dbFuture;
  List<SongModel> songs = List<SongModel>();
  int book;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadListView(context));
  }

  void loadListView(BuildContext context) {
    loader.showWidget();
    dbFuture = db.initializeDatabase();
    dbFuture.then((database) {
      Future<List<SongModel>> songListFuture = db.getSongList(Columns.ownsongs);
      songListFuture.then((songList) {
        setState(() {
          songs = songList;
          loader.hideWidget();
          if (songs.length == 0) notice.showWidget();
          else notice.hideWidget();
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(  
        children: <Widget>[          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: ListView.builder(
              itemCount: songs.length,
              //itemBuilder: songListView,
              itemBuilder: (BuildContext context, int index) {
                return SongItem('SongDraft_' + songs[index].songid.toString(), songs[index], widget.books, context);
              }
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: notice,
          ),      
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: loader,
          ),
          Container(
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height - 210,
                left: MediaQuery.of(context).size.width - 100),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: FloatingActionButton(
              tooltip: LangStrings.addASong,
              child: Icon(Icons.add),
              onPressed: newSong,
            ),
          ),
        ],
      ),
    );
  }

  void newSong() {
    SongModel song = new SongModel(0, Columns.ownsongs, "S", 0, "", "", "", "", "", 0, "");
    navigateToDraft(song, LangStrings.draftASong);
  }

  void navigateToDraft(SongModel song, String title) async {
      bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
        return SongEdit(song, title);
      }
    ));

    if (result == true) {
      loadListView(context);
    }
  }

}
