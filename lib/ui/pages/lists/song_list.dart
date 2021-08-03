import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:card_swiper/card_swiper.dart';

import '../../../utils/colors.dart';
import '../../../services/app_settings.dart';
import '../../../services/app_helper.dart';
import '../../../data/models/list_item.dart';
import '../../../data/models/book_model.dart';
import '../../../data/models/song_model.dart';
import '../../../data/app_database.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/preferences.dart';
import '../../widgets/as_informer.dart';
import '../../widgets/as_loader.dart';
import '../../pages/songs/song_view.dart';
import '../songs/song_item.dart';

class SongList extends StatefulWidget {
  final List<BookModel> books;

  const SongList(this.books);

  @override
  createState() => SongListState();
}

class SongListState extends State<SongList> {
  AppDatabase db = AppDatabase();

  AsLoader loader = AsLoader.setUp(ColorUtils.primaryColor);
  AsInformer notice = AsInformer.setUp(
      3, AppStrings.noSongs, Colors.red, Colors.transparent, Colors.white, 10);

  Future<Database> dbFuture;
  List<ListItem<BookModel>> selected = [], bookList = [];
  List<SongModel> songs = [];
  int book;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initBuild(context));
  }

  /// Method to run anything that needs to be run immediately after Widget build
  void initBuild(BuildContext context) async {
    String bookstr = await Preferences.getSharedPreferenceStr(
        SharedPreferenceKeys.selectedBooks);
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
      decoration: Provider.of<AppSettings>(context).isDarkMode
          ? BoxDecoration()
          : BoxDecoration(
              image: DecorationImage(
                image: new AssetImage(AppStrings.appBgImage),
                fit: BoxFit.cover,
              ),
            ),
      child: Stack(
        children: <Widget>[
          topPanel(),
          midPanel(),
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

  Widget bookListView(BuildContext context, int index) {
    return Container(
      width: 100,
      child: GestureDetector(
        onTap: () {
          setCurrentBook(widget.books[index].categoryid);
        },
        child: Card(
          elevation: 5,
          color: ColorUtils.white,
          child: Hero(
            tag: widget.books[index].bookid,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: Text(
                  bookCountString(
                      widget.books[index].title, widget.books[index].qcount),
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).primaryColor,
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

  Widget topPanel() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 100,
            child: Swiper(
              layout: SwiperLayout.STACK,
              itemBuilder: bookListView,
              itemCount: widget.books.length,
              itemWidth: 200,
              autoplay: true,
              duration: 5000,
            ),
          ),
        ],
      ),
    );
  }

  Widget midPanel() {
    return Container(
      height: MediaQuery.of(context).size.height - 150,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      margin: EdgeInsets.only(top: 100),
      child: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (BuildContext context, int index) {
          return SongItem('SongIndex_' + songs[index].songid.toString(),
              songs[index], widget.books, context);
        },
      ),
    );
  }

  void setCurrentBook(int _book) {
    book = _book;
    songs.clear();
    loadListView();
  }

  void onBookSelected(ListItem tapped) {
    setState(() {
      tapped.isSelected = !tapped.isSelected;
    });
    if (tapped.isSelected) {
      try {
        selected.add(tapped);
      } catch (Exception) {}
    } else {
      try {
        selected.remove(tapped);
      } catch (Exception) {}
    }
  }

  void navigateToSong(SongModel song, String songbook) async {
    bool haschorus = false;
    if (song.content.contains("CHORUS")) haschorus = true;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return SongView(song, haschorus, songbook);
        },
      ),
    );
  }
}
