import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:provider/provider.dart';
import 'package:vsongbook/helpers/AppSettings.dart';
import 'package:vsongbook/models/BookModel.dart';
import 'package:vsongbook/models/SongModel.dart';
import 'package:vsongbook/helpers/SqliteHelper.dart';
import 'package:vsongbook/screens/EeSongView.dart';
import 'package:vsongbook/utils/Constants.dart';
import 'package:vsongbook/widgets/AsProgressWidget.dart';

class AsFavorites extends StatefulWidget {
  @override
  createState() => AsFavoritesState();
}

class AsFavoritesState extends State<AsFavorites> {
  AsProgressWidget progressWidget =
      AsProgressWidget.getProgressWidget(LangStrings.Sis_Patience);
  TextEditingController txtSearch = new TextEditingController(text: "");
  SqliteHelper db = SqliteHelper();

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
          new Container(
            margin: EdgeInsets.only(top: 5),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: new Column(
              children: <Widget>[
                searchBox(),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 100,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: progressWidget,
          ),
          Container(
            height: MediaQuery.of(context).size.height - 100,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            margin: EdgeInsets.only(top: 60),
            child: ListView.builder(
              itemCount: songs.length,
              itemBuilder: songListView,
            ),
          ),
        ],
      ),
    );
  }

  Widget searchBox() {
    return new Card(
      elevation: 2,
      child: new TextField(
        controller: txtSearch,
        style: TextStyle(fontSize: 18),
        decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsetsDirectional.only(end: 12.0),
              child: IconButton(
                icon: Icon(Icons.search),
                onPressed: () => searchSong(),
              ),
            ),
            suffixIcon: Padding(
              padding: const EdgeInsetsDirectional.only(end: 12.0),
              child: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () => clearSearch(),
              ),
            ),
            hintText: LangStrings.SearchNow,
            hintStyle: TextStyle(fontSize: 18)),
        onChanged: (value) {
          searchSong();
        },
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
      songContent = songContent + LangStrings.HasChorus;
      songContent = songContent + verses.length.toString() + LangStrings.Verses;
    } else {
      songContent = songContent + LangStrings.NoChorus;
      songContent = songContent + verses.length.toString() + LangStrings.Verses;
    }

    return Card(
      elevation: 2,
      child: ListTile(
        title: Text(songTitle,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        subtitle: Text(songContent, style: TextStyle(fontSize: 18)),
        onTap: () {
          navigateToSong(songs[index], songTitle,
              "Song #" + songs[index].number.toString() + " - " + songbook);
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
          progressWidget.hideProgress();
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

  void navigateToSong(SongModel song, String title, String songbook) async {
    bool haschorus = false;
    if (song.content.contains("CHORUS")) haschorus = true;
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EeSongView(song, haschorus, title, songbook);
    }));
  }
}
