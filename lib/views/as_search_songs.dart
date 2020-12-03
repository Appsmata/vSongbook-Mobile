import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:provider/provider.dart';
import 'package:vsongbook/helpers/app_settings.dart';
import 'package:vsongbook/models/book_model.dart';
import 'package:vsongbook/models/song_model.dart';
import 'package:vsongbook/helpers/app_database.dart';
import 'package:vsongbook/screens/song_view.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:vsongbook/utils/constants.dart';
import 'package:vsongbook/widgets/as_progress.dart';
import 'package:vsongbook/widgets/as_song_item.dart';
import 'package:vsongbook/views/as_text_view.dart';

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
  AsProgress asProgress = AsProgress.getProgress(LangStrings.Sis_Patience);
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
      child: new Stack(
        children: <Widget>[          
          Container(
            height: 110,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              itemCount: books.length,
              itemBuilder: bookListView,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 200,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            margin: EdgeInsets.only(top: 105),
            child: ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                return AsSongItem('SongSearch_' + songs[index].songid.toString(), songs[index], context);
              }
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 200,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: asProgress,
          ),
        ],
      ),
    );
  }
  
  Widget bookListView(BuildContext context, int index) {
    return Container(
      width: 100,
      margin: EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () {
          setCurrentBook(books[index].categoryid);
        },
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          child: Hero(
              tag: books[index].bookid,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: new BoxDecoration( 
                  color: Provider.of<AppSettings>(context).isDarkMode ? Colors.black : Colors.deepOrange,
                  border: Border.all(color: Provider.of<AppSettings>(context).isDarkMode ? Colors.white : Colors.orange),
                  borderRadius: BorderRadius.all(Radius.circular(60)),
                ),
                child: Center(
                  child: Text(
                    books[index].title + ' (' + books[index].qcount.toString() + ')',
                    style: TextStyle(
                      fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold,
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

  Widget listView(BuildContext context, int index) {
    int category = songs[index].bookid;
    String songBook = "Songs of Worship";
    String songTitle = songs[index].number.toString() + ". " + songs[index].title;
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
          asProgress.hideProgress();
        });
      });
    });
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
      return SongView(song, haschorus, title, songbook);
    }));
  }
}

class BookItem<T> {
  bool isSelected = false;
  T data;
  BookItem(this.data);
}
