import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animated_floatactionbuttons/animated_floatactionbuttons.dart';
import 'package:wakelock/wakelock.dart';

import '../../../utils/app_utils.dart';
import '../../../services/app_helper.dart';
import '../../../services/app_settings.dart';
import '../../../data/app_database.dart';
import '../../../data/models/song_model.dart';
import '../../../ui/widgets/as_slider.dart';
import '../../../ui/views/view_helper.dart';

class SongView extends StatefulWidget {
  final String book;
  final SongModel song;
  final bool hasChorus;

  SongView(this.song, this.hasChorus, this.book);

  @override
  State<StatefulWidget> createState() {
    return SongViewState(this.song, this.hasChorus, this.book);
  }
}

class SongViewState extends State<SongView> {
  SongViewState(this.song, this.hasChorus, this.book);
  final globalKey = GlobalKey<ScaffoldState>();
  AppDatabase db = AppDatabase();

  var appBar = AppBar(), songVerses;
  String book, songContent;
  bool hasChorus;
  SongModel song;
  int curStanza = 0, curSong = 0;
  List<String> verseTexts, verseTitles, verseInfos;

  @override
  Widget build(BuildContext context) {
    curSong = song.songid;
    songContent = song.content.replaceAll("\\n", "\n").replaceAll("''", "'");

    if (Provider.of<AppSettings>(context).isScreenAwake)
      Wakelock.enable();
    else
      Wakelock.disable();

    if (verseTexts == null) setSongContent();
    bool isFavourited(int favorite) => favorite == 1 ?? false;

    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, true);
      },
      child: Scaffold(
        key: globalKey,
        appBar: AppBar(
          title: Text(songViewerTitle(song.number, song.title, song.alias)),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                  isFavourited(song.isfav) ? Icons.star : Icons.star_border),
              onPressed: () => favoriteSong(db, song, context),
            ),
            menuPopup(context),
          ],
        ),
        body: mainBody(),
        floatingActionButton: AnimatedFloatingActionButton(
          fabButtons: floatingButtons(context, song, songContent),
          animatedIconData: AnimatedIcons.menu_close,
        ),
      ),
    );
  }

  Widget mainBody() {
    return Container(
      decoration: Provider.of<AppSettings>(context).isDarkMode
          ? BoxDecoration()
          : BoxDecoration(
              image: DecorationImage(
                image: new AssetImage(AppStrings.appBgImage),
                fit: BoxFit.cover,
              ),
            ),
      child: bodypanel(),
    );
  }

  Widget bodypanel() {
    return AsSlider(
      tabsWidth: 50,
      indicatorColor: Provider.of<AppSettings>(context).isDarkMode
          ? Colors.white
          : Colors.deepOrange,
      indicatorWidth: 7,
      tabsElevation: 5,
      contentScrollAxis: Axis.vertical,
      tabs: List<Tab>.generate(
        verseInfos.length,
        (int index) {
          return Tab(
            child: Center(
              child: Text(
                verseInfos[index],
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
          );
        },
      ),
      contents: List<Widget>.generate(
        verseInfos.length,
        (int index) {
          return Container(
            child: tabsContent(
              index,
              lyricsString(verseTexts[index]),
            ),
          );
        },
      ),
    );
  }

  Widget tabsContent(int index, String lyrics) {
    double nfontsize = getFontSize(
      lyrics.length + 20,
      MediaQuery.of(context).size.height - 200,
      MediaQuery.of(context).size.width - 100,
    );

    return Stack(
      children: <Widget>[
        verseText(lyrics, nfontsize),
        verseTitle(verseTitles[index]),
        Container(
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height - 165,
            left: 15,
          ),
          child: Row(children: [
            copyVerse(index, lyrics, context),
            shareVerse(song, index, lyrics),
          ]),
        ),
      ],
    );
  }

  Widget verseTitle(String verseTitle) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        margin: EdgeInsets.only(top: 10, left: 10),
        child: Column(
          children: <Widget>[
            Container(
              width: 200,
              height: 50,
              decoration: BoxDecoration(
                color: Provider.of<AppSettings>(context).isDarkMode
                    ? Colors.black
                    : Colors.orange,
                border: Border.all(color: Colors.white),
                boxShadow: [BoxShadow(blurRadius: 5)],
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: Center(
                child: Text(
                  verseTitle,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget verseText(String lyrics, double fontsize) {
    return Stack(children: <Widget>[
      Container(
        height: MediaQuery.of(context).size.height - 190,
        margin: EdgeInsets.only(top: 25),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Card(
          elevation: 5,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                lyrics,
                style: TextStyle(fontSize: fontsize),
              ),
            ),
          ),
        ),
      ),
    ]);
  }

  Future<void> setSongContent() async {
    verseInfos = [];
    verseTitles = [];
    verseTexts = [];
    songVerses = song.content.split("\\n\\n");
    int verseCount = songVerses.length;

    if (hasChorus) {
      String chorus = songVerses[1].toString().replaceAll("CHORUS\\n", "");

      verseInfos.add("1");
      verseInfos.add("C");
      verseTitles.add(verseOfString("1", verseCount - 1));
      verseTitles.add('CHORUS');
      verseTexts.add(songVerses[0]);
      verseTexts.add(chorus);

      try {
        for (int i = 2; i < verseCount; i++) {
          verseInfos.add(i.toString());
          verseInfos.add("C");
          verseTitles.add(verseOfString(i.toString(), verseCount - 1));
          verseTitles.add('CHORUS');
          verseTexts.add(songVerses[i]);
          verseTexts.add(chorus);
        }
      } catch (Exception) {}
    } else {
      try {
        for (int i = 0; i < verseCount; i++) {
          verseInfos.add((i + 1).toString());
          verseTitles.add(verseOfString((i + 1).toString(), verseCount));
          verseTexts.add(songVerses[i]);
        }
      } catch (Exception) {}
    }
  }
}
