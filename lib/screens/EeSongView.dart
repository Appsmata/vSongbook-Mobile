import 'dart:math';

import 'package:animated_floatactionbuttons/animated_floatactionbuttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vsongbook/helpers/AppSettings.dart';
import 'package:vsongbook/helpers/SqliteHelper.dart';
import 'package:vsongbook/models/SongModel.dart';
import 'package:vsongbook/screens/EeSongEdit.dart';
import 'package:vertical_tabs/vertical_tabs.dart';
import 'package:share/share.dart';
import 'package:vsongbook/utils/Constants.dart';

class EeSongView extends StatefulWidget {
  final bool haschorus;
  final SongModel song;
  final String songtitle;
  final String songbook;

  EeSongView(this.song, this.haschorus, this.songtitle, this.songbook);

  @override
  State<StatefulWidget> createState() {
    return EeSongViewState(
        this.song, this.haschorus, this.songtitle, this.songbook);
  }
}

class EeSongViewState extends State<EeSongView> {
  EeSongViewState(this.song, this.haschorus, this.songtitle, this.songbook);
  final globalKey = new GlobalKey<ScaffoldState>();
  SqliteHelper db = SqliteHelper();

  var appBar = AppBar(), songVerses;
  String songtitle, songbook;
  bool haschorus;
  SongModel song;
  int curStanza = 0, curSong = 0;
  List<String> verseTexts, verseTitles, verseInfos;
  String songTitle, songContent;

  void getListView() async {
    await setContent();
  }

  @override
  Widget build(BuildContext context) {
    curSong = song.songid;
    songTitle = song.title;
    songContent = song.content.replaceAll("\\n", "\n").replaceAll("''", "'");

    if (verseTexts == null) {
      verseInfos = List<String>();
      verseTitles = List<String>();
      verseTexts = List<String>();
      getListView();
    }
    bool isFavourited(int favorite) => favorite == 1 ?? false;

    return WillPopScope(
      onWillPop: () {
        moveToLastScreen();
      },
      child: Scaffold(
        key: globalKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text(songtitle),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                isFavourited(song.isfav) ? Icons.star : Icons.star_border,
              ),
              onPressed: () => favoriteSong(),
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => settingsDialog());
              },
            ),
          ],
        ),
        body: mainBody(),
        floatingActionButton: AnimatedFloatingActionButton(
          fabButtons: floatingButtons(),
          animatedIconData: AnimatedIcons.menu_close,
        ),
      ),
    );
  }

  Widget settingsDialog() {
    return new AlertDialog(
      title: new Text(
        LangStrings.DisplaySettings,
        style: new TextStyle(color: Colors.deepOrange, fontSize: 25),
      ),
      content: new Container(
        height: 50,
        width: double.maxFinite,
        child: ListView(children: <Widget>[
          Consumer<AppSettings>(builder: (context, AppSettings settings, _) {
            return ListTile(
              onTap: () {},
              leading: Icon(settings.isDarkMode
                  ? Icons.brightness_4
                  : Icons.brightness_7),
              title: Text(LangStrings.DarkMode),
              trailing: Switch(
                onChanged: (bool value) => settings.setDarkMode(value),
                value: settings.isDarkMode,
              ),
            );
          }),
          Divider(),
        ]),
      ),
      actions: <Widget>[
        new Container(
          margin: EdgeInsets.all(5),
          child: FlatButton(
            child:
                Text(LangStrings.OkayDone, style: new TextStyle(fontSize: 20)),
            color: Colors.deepOrange,
            //textColor: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }

  Widget mainBody() {
    return Center(
      child: Container(
        constraints: BoxConstraints.expand(),
        child: new Stack(
          children: <Widget>[
            songViewer(),
            songBook(),
          ],
        ),
      ),
    );
  }

  Widget songBook() {
    return Container(
      padding: const EdgeInsets.all(5),
      height: 50,
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height - 160),
      child: Center(
        child: Text(
          songbook,
          style: new TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Provider.of<AppSettings>(context).isDarkMode
                  ? Colors.white
                  : Colors.deepOrange),
        ),
      ),
    );
  }

  Widget songViewer() {
    return VerticalTabs(
        tabsWidth: 75,
        contentScrollAxis: Axis.vertical,
        tabs: List<Tab>.generate(
          verseInfos.length,
          (int index) {
            return new Tab(
              child: Center(
                child: Text(verseInfos[index],
                    style: new TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),
            );
          },
        ),
        contents: List<Widget>.generate(
          verseInfos.length,
          (int index) {
            return new Container(
              child: tabsContent(index),
              decoration: Provider.of<AppSettings>(context).isDarkMode
                  ? BoxDecoration()
                  : BoxDecoration(
                      image: DecorationImage(
                          image: new AssetImage("assets/images/bg.jpg"),
                          fit: BoxFit.cover)),
            );
          },
        ));
  }

  double getFontSize(int characters, double height, double width) {
    height = height - 300;
    width = width - 100;
    return sqrt((height * width) / characters);
  }

  Widget tabsContent(int index) {
    var lines = verseTexts[index].split("\\n");
    String lyrics =
        verseTexts[index].replaceAll("\\n", "\n").replaceAll("''", "'");
    double nfontsize = getFontSize(lyrics.length,
        MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);

    return new Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height - 180,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Card(
              elevation: 2,
              child: new Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: new Text(
                    lyrics,
                    style: new TextStyle(fontSize: nfontsize),
                  ),
                ),
              )),
        ),
        Container(
          margin:
              EdgeInsets.only(top: MediaQuery.of(context).size.height - 215),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: new Column(
            children: <Widget>[
              new Center(
                child: new Container(
                  width: 200,
                  height: 50,
                  decoration: new BoxDecoration(
                      color: Provider.of<AppSettings>(context).isDarkMode
                          ? Colors.black
                          : Colors.orange,
                      border: Border.all(color: Colors.white),
                      boxShadow: [BoxShadow(blurRadius: 5)],
                      borderRadius:
                          new BorderRadius.all(new Radius.circular(5))),
                  child: new Center(
                    child: new Text(
                      verseTitles[index],
                      style: new TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> floatingButtons() {
    return <Widget>[
      deleteButton(),
      FloatingActionButton(
        heroTag: null,
        child: Icon(Icons.content_copy),
        tooltip: LangStrings.CopySong,
        onPressed: copySong,
      ),
      FloatingActionButton(
        heroTag: null,
        child: Icon(Icons.share),
        tooltip: LangStrings.ShareSong,
        onPressed: shareSong,
      ),
      FloatingActionButton(
        heroTag: null,
        child: Icon(Icons.edit),
        tooltip: LangStrings.EditSong,
        onPressed: editSong,
      ),
    ];
  }

  Widget deleteButton() {
    if (song.bookid == Columns.ownsongs)
      return FloatingActionButton(
        heroTag: null,
        child: Icon(Icons.delete),
        tooltip: LangStrings.EditSong,
        onPressed: deleteSong,
      );
    else
      return null;
  }

  Future<void> setContent() async {
    verseInfos = [];
    verseTitles = [];
    verseTexts = [];
    songVerses = song.content.split("\\n\\n");
    int verseCount = songVerses.length;

    if (haschorus) {
      String chorus = songVerses[1].toString().replaceAll("CHORUS\\n", "");

      verseInfos.add("1");
      verseInfos.add("C");
      verseTitles.add("VERSE 1 of " + (verseCount - 1).toString());
      verseTitles.add('CHORUS');
      verseTexts.add(songVerses[0]);
      verseTexts.add(chorus);

      try {
        for (int i = 2; i < verseCount; i++) {
          String verseno = i.toString();
          verseInfos.add(verseno);
          verseInfos.add("C");
          verseTitles
              .add('VERSE ' + verseno + ' of ' + (verseCount - 1).toString());
          verseTitles.add('CHORUS');
          verseTexts.add(songVerses[i]);
          verseTexts.add(chorus);
        }
      } catch (Exception) {}
    } else {
      try {
        for (int i = 0; i < verseCount; i++) {
          String verseno = (i + 1).toString();
          verseInfos.add(verseno);
          verseTitles.add('VERSE ' + verseno + ' of ' + verseCount.toString());
          verseTexts.add(songVerses[i]);
        }
      } catch (Exception) {}
    }
  }

  void copySong() {
    Clipboard.setData(ClipboardData(text: songTitle + "\n\n" + songContent));
    globalKey.currentState.showSnackBar(new SnackBar(
      content: new Text(LangStrings.Song_Copied),
    ));
  }

  void shareSong() {
    Share.share(
      songTitle +
          "\n\n" +
          songContent +
          "\n\nvia #vSongBook " +
          "https://Appsmata.com/vSongBook",
      subject: "Share the song: " + songTitle,
    );
  }

  void editSong() async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EeSongEdit(song, "Editting: " + songTitle);
    }));
  }

  void deleteSong() async {
    int result = await db.deleteSong(song.songid);
    if (result != 0) moveToLastScreen();
  }

  void favoriteSong() {
    if (song.isfav == 1)
      db.favouriteSong(song, false);
    else
      db.favouriteSong(song, true);
    globalKey.currentState.showSnackBar(new SnackBar(
      content: new Text(songTitle + " " + LangStrings.Song_Liked),
    ));
    //notifyListeners();
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}
