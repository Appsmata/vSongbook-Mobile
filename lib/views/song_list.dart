import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vsongbook/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:vsongbook/helpers/app_settings.dart';
import 'package:vsongbook/models/book_model.dart';
import 'package:vsongbook/models/song_model.dart';
import 'package:vsongbook/helpers/app_database.dart';
import 'package:vsongbook/screens/song_view.dart';
import 'package:vsongbook/views/song_item.dart';
import 'package:vsongbook/widgets/as_loader.dart';
import 'package:vsongbook/utils/constants.dart';
import 'package:vsongbook/utils/preferences.dart';

class SongList extends StatefulWidget {
	final List<BookModel> books;
  const SongList(this.books);

  @override
  createState() => SongListState();

}

class SongListState extends State<SongList> {
  AsLoader loader = AsLoader();
  AppDatabase db = AppDatabase();

  SongListState();
  Future<Database> dbFuture;
  List<SongModel> songs = List<SongModel>();
  int book;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initLoad(context));
  }

  void initLoad(BuildContext context) async {
    loader.showWidget();
    String bookstr = await Preferences.getSharedPreferenceStr(SharedPreferenceKeys.selectedBooks);
    var bookids = bookstr.split(",");
    book = int.parse(bookids[0]);
    loadListView();
  }

  void loadListView() async {
    loader.showWidget();
    
    dbFuture = db.initializeDatabase();
    dbFuture.then((database) {
      Future<List<SongModel>> songListFuture = db.getSongList(book);
      songListFuture.then((songList) {
        setState(() {
          songs = songList;
          loader.hideWidget();
        });
      });
    });
  }

  void setCurrentBook(int _book) {
    book = _book;
    songs.clear();
    loadListView();
  }

  @override
  Widget build(BuildContext context) {
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
                    itemCount: widget.books.length,
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
                return SongItem('SongIndex_' + songs[index].songid.toString(), songs[index], widget.books, context);
              }
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 200,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: loader,
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
          setCurrentBook(widget.books[index].categoryid);
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: BorderSide(color: Provider.of<AppSettings>(context).isDarkMode ? ColorUtils.white : ColorUtils.secondaryColor, width: 1.5),
          ),      
          color: Provider.of<AppSettings>(context).isDarkMode ? ColorUtils.black : ColorUtils.primaryColor,
          elevation: 5,
          child: Hero(
            tag: widget.books[index].bookid,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: Text(
                  widget.books[index].title + ' (' + widget.books[index].qcount.toString() + ')',
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
