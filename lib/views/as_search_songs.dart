import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:provider/provider.dart';
import 'package:vsongbook/helpers/app_settings.dart';
import 'package:vsongbook/models/book_model.dart';
import 'package:vsongbook/models/song_model.dart';
import 'package:vsongbook/helpers/app_database.dart';
import 'package:vsongbook/screens/ee_song_view.dart';
import 'package:vsongbook/utils/constants.dart';
import 'package:vsongbook/widgets/as_progress.dart';
import 'package:vsongbook/widgets/as_text_view.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:vsongbook/widgets/as_song_item.dart';

class AsSearchSongs extends StatefulWidget {
  final int book;
  AsSearchSongs({this.book});

  @override
  createState() => AsSearchSongsState(book: this.book);

  static Widget getList(int songbook) {
    return new AsSearchSongs(
      book: songbook,
    );
  }
}

class AsSearchSongsState extends State<AsSearchSongs> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AsProgress progressWidget = AsProgress.getAsProgress(LangStrings.Sis_Patience);
  TextEditingController txtSearch = new TextEditingController(text: "");
  AsTextView textResult = AsTextView.setUp(LangStrings.SearchResult, 15, false);
  AppDatabase db = AppDatabase();
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey = GlobalKey<LiquidPullToRefreshState>();
  final ScrollController _scrollController = ScrollController();

  AsSearchSongsState({this.book});
  Future<Database> dbFuture;
  List<BookModel> books;
  List<SongModel> songs;
  int book;

  Future<void> handleRefresh() {
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(seconds: 3), () {
      completer.complete();
    });
    
    return completer.future.then<void>((_) {
      _scaffoldKey.currentState?.showSnackBar(SnackBar(
        content: const Text('Refresh complete'),
        action: SnackBarAction(
            label: 'RETRY',
            onPressed: () {
              _refreshIndicatorKey.currentState.show();
            }
          )
        )
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    if (songs == null) {
      books = [];
      songs = [];
      updateBookList();
      updateSongList();
    }

    return new Container(
      child: new Stack(
        children: <Widget>[
          new Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: new Column(
              children: <Widget>[
                Container(
                  height: 55,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    itemCount: books.length,
                    itemBuilder: bookListView,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 100,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            margin: EdgeInsets.only(top: 55),
            child: LiquidPullToRefresh(
              key: _refreshIndicatorKey,	// key if you want to add
              onRefresh: handleRefresh,	// refresh callback
              child: Scrollbar(
                isAlwaysShown: true,
                controller: _scrollController,
                child: ListView.builder(
                  itemCount: songs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return AsSongItem(songs[index], context);
                  }
                ),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 200,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: progressWidget,
          ),
        ],
      ),
    );
  }

  Widget bookListView(BuildContext context, int index) {
    return Container(
      width: 160,
      child: GestureDetector(
        onTap: () {
          setCurrentBook(books[index].categoryid);
        },
        child: Card(
          elevation: 5,
          child: Hero(
            tag: books[index].bookid,
            child: Container(
              padding: const EdgeInsets.all(3),
              child: Center(
                child: Text(
                  books[index].title +
                      ' (' +
                      books[index].qcount.toString() +
                      ')',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void updateBookList() {
    dbFuture = db.initializeDatabase();
    dbFuture.then((database) {
      Future<List<BookModel>> bookListFuture = db.getBookList();
      bookListFuture.then((bookList) {
        setState(() {
          books = bookList;
        });
      });
    });
  }

  void updateSongList() {
    dbFuture = db.initializeDatabase();
    dbFuture.then((database) {
      Future<List<SongModel>> songListFuture = db.getSongList(book);
      songListFuture.then((songList) {
        setState(() {
          songs = songList;
          progressWidget.hideProgress();
        });
      });
    });
  }

  void setCurrentBook(int _book) {
    book = _book;
    songs.clear();
    updateSongList();
  }

  void navigateToSong(SongModel song, String songbook) async {
    bool haschorus = false;
    if (song.content.contains("CHORUS")) haschorus = true;
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EeSongView(song, haschorus, songbook);
    }));
  }
}

class BookItem<T> {
  bool isSelected = false;
  T data;
  BookItem(this.data);
}
