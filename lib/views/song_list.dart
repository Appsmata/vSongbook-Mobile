import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vsongbook/utils/colors.dart';
import 'package:vsongbook/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:vsongbook/helpers/app_base.dart';
import 'package:vsongbook/helpers/app_settings.dart';
import 'package:vsongbook/models/book_model.dart';
import 'package:vsongbook/models/song_model.dart';
import 'package:vsongbook/helpers/app_database.dart';
import 'package:vsongbook/screens/song_view.dart';
import 'package:vsongbook/views/song_item.dart';
import 'package:vsongbook/widgets/as_progress.dart';
import 'package:vsongbook/widgets/as_text_view.dart';

class SongList extends StatefulWidget {
  final int book;
  SongList({this.book});

  @override
  createState() => SongListState(book: this.book);

  static Widget getList(int songbook) {
    return SongList(
      book: songbook,
    );
  }
}

class SongListState extends State<SongList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AsProgress progressWidget = AsProgress.getAsProgress(LangStrings.somePatience);
  TextEditingController txtSearch = new TextEditingController(text: "");
  AsTextView textResult = AsTextView.setUp(LangStrings.searchResult, 15, false);
  AppDatabase db = AppDatabase();
  final ScrollController _scrollController = ScrollController();

  SongListState({this.book});
  Future<Database> dbFuture;
  List<BookModel> books;
  List<SongModel> songs;
  int book;

  @override
  Widget build(BuildContext context) {
    if (songs == null) {
      books = [];
      songs = [];
      updateBookList();
      updateSongList();
    }

    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              children: <Widget>[
                Container(
                  height: 105,
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
            margin: EdgeInsets.only(top: 98),
            child: Divider(),
          ),
          
          Container(
            height: MediaQuery.of(context).size.height - 150,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            margin: EdgeInsets.only(top: 105),
            child: ListView.builder(
              itemCount: songs.length,
              itemBuilder: (BuildContext context, int index) {
                return SongItem('SongIndex_' + songs[index].songid.toString(), songs[index], books, context);
              }
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
      width: 100,
      padding: const EdgeInsets.only(bottom: 5),
      child: GestureDetector(
        onTap: () {
          setCurrentBook(books[index].categoryid);
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: BorderSide(color: Provider.of<AppSettings>(context).isDarkMode ? ColorUtils.white : ColorUtils.secondaryColor, width: 1.5),
          ),      
          color: Provider.of<AppSettings>(context).isDarkMode ? ColorUtils.black : ColorUtils.primaryColor,
          elevation: 5,
          child: Hero(
            tag: books[index].bookid,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: Text(
                  books[index].title + ' (' + books[index].qcount.toString() + ')',
                  style: TextStyle(
                    fontSize: 15, color: ColorUtils.white,
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
      return SongView(song, haschorus, songbook);
    }));
  }
}

class BookItem<T> {
  bool isSelected = false;
  T data;
  BookItem(this.data);
}
