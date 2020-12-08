import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:provider/provider.dart';
import 'package:vsongbook/helpers/app_settings.dart';
import 'package:vsongbook/models/song_model.dart';
import 'package:vsongbook/helpers/app_database.dart';
import 'package:vsongbook/screens/song_edit.dart';
import 'package:vsongbook/screens/song_view.dart';
import 'package:vsongbook/utils/constants.dart';
import 'package:vsongbook/widgets/as_progress.dart';

class SongPad extends StatefulWidget {
  @override
  createState() => SongPadState();
}

class SongPadState extends State<SongPad> {
  AsProgress progress = AsProgress.getAsProgress(LangStrings.somePatience);
  TextEditingController txtSearch = new TextEditingController(text: "");
  final ScrollController _scrollController = ScrollController();
  AppDatabase db = AppDatabase();

  Future<Database> dbFuture;
  List<SongModel> songs;

  @override
  Widget build(BuildContext context) {
    if (songs == null) {
      songs = [];
      updateListView();
    }
    return Container(
      decoration: Provider.of<AppSettings>(context).isDarkMode
          ? BoxDecoration()
          : BoxDecoration(
              image: DecorationImage(
                  image: new AssetImage("assets/images/bg.jpg"),
                  fit: BoxFit.cover)),
      child: Stack(
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
          Container(
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height - 210,
                left: MediaQuery.of(context).size.width - 100),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: FloatingActionButton(
              tooltip: LangStrings.addASong,
              child: Icon(Icons.add),
              onPressed: newSong,
            ),
          ),
        ],
      ),
    );
  }

  void newSong() {
    SongModel song = new SongModel(0, Columns.ownsongs, "S", 0, "", "", "", "", "", 0, "");
    navigateToDraft(song, LangStrings.draftASong);
  }

  void navigateToDraft(SongModel song, String title) async {
      bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
        return SongEdit(song, title);
      }
    ));

    if (result == true) {
      updateListView();
    }
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
          navigateToSong(songs[index]);
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

  void navigateToSong(SongModel song) async {
    bool haschorus = false;
    if (song.content.contains("CHORUS")) haschorus = true;
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SongView(song, haschorus, "My Own Songs");
    }));
  }
}
