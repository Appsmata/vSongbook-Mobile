import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../../services/app_settings.dart';
import '../../../data/models/book_model.dart';
import '../../../data/models/song_model.dart';
import '../../../data/app_database.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/db_utils.dart';
import '../../../utils/colors.dart';
import '../../widgets/as_informer.dart';
import '../../widgets/as_loader.dart';
import '../songs/song_edit.dart';
import '../songs/song_item.dart';

class SongPad extends StatefulWidget {
  final List<BookModel> books;

  const SongPad(this.books);

  @override
  createState() => SongPadState();
}

class SongPadState extends State<SongPad> {
  AppDatabase db = AppDatabase();

  AsLoader loader = AsLoader.setUp(ColorUtils.primaryColor);
  AsInformer notice = AsInformer.setUp(
      3, AppStrings.noDrafts, Colors.red, Colors.transparent, Colors.white, 10);

  SongPadState();
  Future<Database> dbFuture;
  List<SongModel> songs = [];
  int book;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initBuild(context));
  }

  /// Method to run anything that needs to be run immediately after Widget build
  void initBuild(BuildContext context) async {
    loadListView();
  }

  void loadListView() {
    loader.showWidget();
    dbFuture = db.initializeDatabase();
    dbFuture.then((database) {
      Future<List<SongModel>> songListFuture = db.getSongList(Columns.ownsongs);
      songListFuture.then((songList) {
        setState(() {
          songs = songList;
          loader.hideWidget();
          if (songs.length == 0)
            notice.show();
          else
            notice.hide();
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
                  return SongItem('SongDraft_' + songs[index].songid.toString(),
                      songs[index], widget.books, context);
                }),
          ),
          Container(
            height: 200,
            child: notice,
          ),
          Container(
            margin: EdgeInsets.only(top: 50),
            height: 200,
            child: Center(
              child: loader,
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height - 210,
                left: MediaQuery.of(context).size.width - 100),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: FloatingActionButton(
              tooltip: AppStrings.addASong,
              child: Icon(Icons.add),
              onPressed: newSong,
            ),
          ),
        ],
      ),
    );
  }

  void newSong() {
    SongModel song =
        SongModel(0, Columns.ownsongs, "S", 0, "", "", "", "", "", 0, "");
    navigateToDraft(song, AppStrings.draftASong);
  }

  void navigateToDraft(SongModel song, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SongEdit(song, title);
    }));

    if (result == true) {
      loadListView();
    }
  }
}
