import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:provider/provider.dart';
import 'package:vsongbook/helpers/AppSettings.dart';
import 'package:vsongbook/models/BookModel.dart';
import 'package:vsongbook/models/SongModel.dart';
import 'package:vsongbook/helpers/SqliteHelper.dart';
import 'package:vsongbook/screens/EeSongView.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:vsongbook/utils/Constants.dart';
import 'package:vsongbook/widgets/AsProgressWidget.dart';
import 'package:vsongbook/views/AsTextView.dart';

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
  AsProgressWidget progressWidget =
      AsProgressWidget.getProgressWidget(LangStrings.Sis_Patience);
  TextEditingController txtSearch = new TextEditingController(text: "");
  AsTextView textResult = AsTextView.setUp(LangStrings.SearchResult, 18, false);
  SqliteHelper db = SqliteHelper();

  AsSearchSongsState({this.book});
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
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: new Column(
              children: <Widget>[
                searchBox(),
                Container(
                  height: 55,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    itemCount: books.length,
                    itemBuilder: bookListView,
                  ),
                ),
                searchCount(),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 200,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: progressWidget,
          ),
          Container(
            height: MediaQuery.of(context).size.height - 200,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            margin: EdgeInsets.only(top: 150),
            child: ListView.builder(
              itemCount: songs.length,
              itemBuilder: listView,
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
        style: TextStyle(
          fontSize: 18,
        ),
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

  Widget searchCount() {
    return new Card(
      elevation: 5,
      child: Hero(
        tag: 0,
        child: Container(
          padding: const EdgeInsets.all(7),
          child: Center(
            child: textResult,
          ),
        ),
      ),
    );
  }

  Widget listView(BuildContext context, int index) {
    int category = songs[index].bookid;
    String songBook = "Songs of Worship";
    String songTitle =
        songs[index].number.toString() + ". " + songs[index].title;
    String strContent = '<h2>' + songTitle + '</h2>';

    var verses = songs[index].content.split("\\n\\n");
    var songConts = songs[index].content.split("\\n");
    strContent =
        strContent + songConts[0] + ' ' + songConts[1] + " ... <br><small><i>";

    try {
      BookModel curbook = books.firstWhere((i) => i.categoryid == category);
      strContent = strContent + "\n" + curbook.title + "; ";
      songBook = curbook.title;
    } catch (Exception) {
      strContent = strContent + "\n";
    }

    if (songs[index].content.contains("CHORUS")) {
      strContent = strContent + LangStrings.HasChorus;
      strContent = strContent + verses.length.toString() + LangStrings.Verses;
    } else {
      strContent = strContent + LangStrings.NoChorus;
      strContent = strContent + verses.length.toString() + LangStrings.Verses;
    }

    return Card(
      elevation: 2,
      child: GestureDetector(
        child: Html(
          data: strContent + '</i></small>',
          style: {
            "html": Style(
              fontSize: FontSize(20.0),
            ),
            "ul": Style(
              fontSize: FontSize(18.0),
            ),
          },
        ),
        onTap: () {
          navigateToSong(songs[index], songTitle,
              "Song #" + songs[index].number.toString() + " - " + songBook);
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
      Future<List<SongModel>> songListFuture = db.getSongList(book);
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
            db.getSongSearch(txtSearch.text);
        songListFuture.then((songList) {
          setState(() {
            songs = songList;
            textResult.setText(songs.length.toString() + " songs found");
          });
        });
      });
    } else {
      updateSongList();
      textResult.setText(LangStrings.SearchResult);
    }
  }

  void clearSearch() {
    txtSearch.clear();
    songs.clear();
    textResult.setText(LangStrings.SearchResult);
    updateSongList();
  }

  void setCurrentBook(int _book) {
    book = _book;
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

class BookItem<T> {
  bool isSelected = false;
  T data;
  BookItem(this.data);
}
