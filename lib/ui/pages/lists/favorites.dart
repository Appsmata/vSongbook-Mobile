import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:provider/provider.dart';

import '../../../utils/colors.dart';
import '../../../services/app_settings.dart';
import '../../../data/models/book_model.dart';
import '../../../data/models/song_model.dart';
import '../../../data/app_database.dart';
import '../../../utils/app_utils.dart';
import '../../widgets/as_informer.dart';
import '../../widgets/as_loader.dart';
import '../songs/song_view.dart';
import '../songs/song_item.dart';

class Favorites extends StatefulWidget {
  final List<BookModel> books;

  const Favorites(this.books);

  @override
  createState() => FavoritesState();
}

class FavoritesState extends State<Favorites> {
  AppDatabase db = AppDatabase();

  AsLoader loader = AsLoader.setUp(ColorUtils.primaryColor);
  AsInformer notice = AsInformer.setUp(
      3, AppStrings.noFavs, Colors.red, Colors.transparent, Colors.white, 10);

  FavoritesState();
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

  void loadListView() async {
    loader.showWidget();
    dbFuture = db.initializeDatabase();
    dbFuture.then((database) {
      Future<List<SongModel>> songListFuture = db.getFavorites();
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
          /*Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              children: <Widget>[
                Container(
                  height: 105,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    itemCount: books.length,
                    itemBuilder: booksView,
                  ),
                ),
              ],
            ),
          ),
          
          Container(
            margin: EdgeInsets.only(top: 98),
            child: Divider(),
          ),*/

          Container(
            //height: MediaQuery.of(context).size.height - 150,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            //margin: EdgeInsets.only(top: 105),
            child: ListView.builder(
                itemCount: songs.length,
                itemBuilder: (BuildContext context, int index) {
                  return SongItem('SongFavs_' + songs[index].songid.toString(),
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
        ],
      ),
    );
  }

  Widget booksView(BuildContext context, int index) {
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
            side: BorderSide(
                color: Provider.of<AppSettings>(context).isDarkMode
                    ? ColorUtils.white
                    : ColorUtils.secondaryColor,
                width: 1.5),
          ),
          color: Provider.of<AppSettings>(context).isDarkMode
              ? ColorUtils.black
              : ColorUtils.primaryColor,
          elevation: 5,
          child: Hero(
            tag: widget.books[index].bookid,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: Text(
                  widget.books[index].title +
                      ' (' +
                      widget.books[index].qcount.toString() +
                      ')',
                  style: TextStyle(
                    fontSize: 15,
                    color: ColorUtils.white,
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
