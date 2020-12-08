import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:provider/provider.dart';
import 'package:vsongbook/utils/constants.dart';
import 'package:vsongbook/helpers/app_settings.dart';
import 'package:vsongbook/models/book_model.dart';
import 'package:vsongbook/models/song_model.dart';
import 'package:vsongbook/helpers/app_database.dart';
import 'package:vsongbook/screens/song_view.dart';
import 'package:vsongbook/widgets/as_progress.dart';

class Favorites extends StatefulWidget {
  @override
  createState() => FavoritesState();
}

class FavoritesState extends State<Favorites> {
  AsProgress progress = AsProgress.getAsProgress(LangStrings.somePatience);
  TextEditingController txtSearch = new TextEditingController(text: "");
  final ScrollController _scrollController = ScrollController();
  AppDatabase db = AppDatabase();

  Future<Database> dbFuture;
  List<BookModel> books;
  List<SongModel> songs;

  @override
  Widget build(BuildContext context) {
    if (songs == null) {
      books = [];
      songs = [];
      updateBookList();
      updateSongList();
    }
    return new Container(
      decoration: Provider.of<AppSettings>(context).isDarkMode
          ? BoxDecoration()
          : BoxDecoration(
              image: DecorationImage(
                  image: new AssetImage("assets/images/bg.jpg"),
                  fit: BoxFit.cover)),
      child: new Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: progress,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            margin: EdgeInsets.only(top: 60),            
            child: Scrollbar(
              isAlwaysShown: true,
              controller: _scrollController,
              child: ListView.builder(
                itemCount: songs.length,
                itemBuilder: songListView,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget songListView(BuildContext context, int index) {
    int category = songs[index].bookid;
    String songbook = "";
    String songTitle = songs[index].title;

    var verses = songs[index].content.split("\\n\\n");
    var songConts = songs[index].content.split("\\n");
    String songContent = songConts[0] + ' ' + songConts[1] + " ...";

    try {
      BookModel curbook = books.firstWhere((i) => i.categoryid == category);
      songContent = songContent + "\n" + curbook.title + "; ";
      songbook = curbook.title;
    } catch (Exception) {
      songContent = songContent + "\n";
    }

    if (songs[index].content.contains("CHORUS")) {
      songContent = songContent + LangStrings.hasChorus;
      songContent = songContent + verses.length.toString() + LangStrings.verses;
    } else {
      songContent = songContent + LangStrings.noChorus;
      songContent = songContent + verses.length.toString() + LangStrings.verses;
    }

    return Card(
      elevation: 2,
      child: ListTile(
        title: Text(songTitle, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        subtitle: Text(songContent, style: TextStyle(fontSize: 18)),
        onTap: () {
          navigateToSong(songs[index], "Song #" + songs[index].number.toString() + " - " + songbook);
        },
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
      Future<List<SongModel>> songListFuture = db.getFavorites();
      songListFuture.then((songList) {
        setState(() {
          songs = songList;
          progress.hideProgress();
        });
      });
    });
  }

  void searchSong() {
    String searchThis = txtSearch.text;
    if (searchThis.length > 0) {
      songs.clear();
      dbFuture = db.initializeDatabase();
      dbFuture.then((database) {
        Future<List<SongModel>> songListFuture =
            db.getFavSearch(txtSearch.text);
        songListFuture.then((songList) {
          setState(() {
            songs = songList;
          });
        });
      });
    } else
      updateSongList();
  }

  void clearSearch() {
    txtSearch.clear();
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
