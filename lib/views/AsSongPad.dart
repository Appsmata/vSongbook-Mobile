import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:provider/provider.dart';
import 'package:vsongbook/helpers/AppSettings.dart';
import 'package:vsongbook/models/SongModel.dart';
import 'package:vsongbook/helpers/SqliteHelper.dart';
import 'package:vsongbook/screens/EeSongEdit.dart';
import 'package:vsongbook/screens/EeSongView.dart';
//import 'package:vsongbook/utils/Preferences.dart';
import 'package:vsongbook/utils/Constants.dart';
import 'package:vsongbook/widgets/AsProgressWidget.dart';

class AsSongPad extends StatefulWidget {
  @override
  createState() => AsSongPadState();
}

class AsSongPadState extends State<AsSongPad> {
  AsProgressWidget progressWidget =
      AsProgressWidget.getProgressWidget(LangStrings.Sis_Patience);
  TextEditingController txtSearch = new TextEditingController(text: "");
  SqliteHelper db = SqliteHelper();

  Future<Database> dbFuture;
  List<SongModel> songs;

  @override
  Widget build(BuildContext context) {
    if (songs == null) {
      songs = [];
      updateListView();
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
          Container(
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height - 210,
                left: MediaQuery.of(context).size.width - 100),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: FloatingActionButton(
              tooltip: 'Add a Song',
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
        new SongModel(0, Columns.ownsongs, "S", 0, "", "", "", "", "", 0, "");
    navigateToDraft(song, 'Draft a Song');
  }

  void navigateToDraft(SongModel song, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EeSongEdit(song, title);
    }));

    if (result == true) {
      updateListView();
    }
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
            hintText: "Search a draft",
            hintStyle: TextStyle(fontSize: 18)),
        onChanged: (value) {
          searchSong();
        },
      ),
    );
  }

  Widget songListView(BuildContext context, int index) {
    String songTitle = songs[index].title;
    String songContent =
        songs[index].content.replaceAll("\\n", " ").replaceAll("CHORUS", " ");
    if (songContent.length > 45)
      songContent = songContent.substring(0, 45) + " ...";
    return Card(
      elevation: 2,
      child: ListTile(
        title: Text(songTitle, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(songContent),
        onTap: () {
          navigateToSong(songs[index], songTitle);
        },
      ),
    );
  }

  void updateListView() {
    dbFuture = db.initializeDatabase();
    dbFuture.then((database) {
      Future<List<SongModel>> songListFuture = db.getSongList(Columns.ownsongs);
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
            db.getDraftSearch(txtSearch.text);
        songListFuture.then((songList) {
          setState(() {
            songs = songList;
          });
        });
      });
    } else
      updateListView();
  }

  void clearSearch() {
    txtSearch.clear();
    songs.clear();
    updateListView();
  }

  void navigateToSong(SongModel song, String title) async {
    bool haschorus = false;
    if (song.content.contains("CHORUS")) haschorus = true;
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EeSongView(song, haschorus, title, "My Own Songs");
    }));
  }
}
