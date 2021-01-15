import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:animated_floatactionbuttons/animated_floatactionbuttons.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vsongbook/helpers/app_base.dart';
import 'package:vsongbook/helpers/app_settings.dart';
import 'package:vsongbook/helpers/app_database.dart';
import 'package:vsongbook/models/song_model.dart';
import 'package:vsongbook/screens/song_edit.dart';
import 'package:vertical_tabs/vertical_tabs.dart';
import 'package:share/share.dart';
import 'package:vsongbook/utils/Constants.dart';
import 'package:wakelock/wakelock.dart';
import 'package:vsongbook/screens/about_app.dart';
import 'package:vsongbook/screens/donate.dart';
import 'package:vsongbook/screens/help_desk.dart';
import 'package:vsongbook/screens/preferences.dart';

class SongView extends StatefulWidget {
  final bool haschorus;
  final SongModel song;
  final String book;

  SongView(this.song, this.haschorus, this.book);

  @override
  State<StatefulWidget> createState() {
    return SongViewState(this.song, this.haschorus, this.book);
  }
}

class SongViewState extends State<SongView> {
  SongViewState(this.song, this.haschorus, this.book);
  final globalKey = GlobalKey<ScaffoldState>();
  AppDatabase db = AppDatabase();

  var appBar = AppBar(), songVerses;
  String book;
  bool haschorus;
  SongModel song;
  int curStanza = 0, curSong = 0;
  List<String> verseTexts, verseTitles, verseInfos;
  String songTitle, songContent;

  int _counter = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  void getListView() async {
    try {
      await setContent();
    }
    catch (Exception) { }
  }

  @override
  Widget build(BuildContext context) {
    curSong = song.songid;
    songTitle = song.title;
    songContent = song.content.replaceAll("\\n", "\n").replaceAll("''", "'");

    if (Provider.of<AppSettings>(context).isScreenAwake) Wakelock.enable();
    else Wakelock.disable();

    if (verseTexts == null) {
      verseInfos = List<String>();
      verseTitles = List<String>();
      verseTexts = List<String>();
      getListView();
    }
    bool isFavourited(int favorite) => favorite == 1 ?? false;

    Widget menuPopup() => PopupMenuButton<int>(
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Text(LangStrings.quickSettings),
        ),
        PopupMenuItem(
          value: 2,
          child: Text(LangStrings.manageApp),
        ),
        PopupMenuItem(
          value: 3,
          child: Text(LangStrings.supportUs),
        ),
        PopupMenuItem(
          value: 4,
          child: Text(LangStrings.helpFeedback),
        ),
        PopupMenuItem(
          value: 5,
          child: Text(LangStrings.aboutTheApp + LangStrings.appName),
        ),
      ],
      onCanceled: () { },
      onSelected: (value) {
        selectedMenu(value, context);
      },
      icon: Icon(
        Theme.of(context).platform == TargetPlatform.iOS ? Icons.more_horiz : Icons.more_vert,
      ),
    );

    return WillPopScope(
      onWillPop: () {
        moveToLastScreen();
      },
      child: Scaffold(
        key: globalKey,
        appBar: AppBar(
          title: Text(book),
          actions: <Widget>[
            IconButton(
              icon: Icon(isFavourited(song.isfav) ? Icons.star : Icons.star_border),
              onPressed: () => favoriteSong(),
            ),
            menuPopup(),
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

  Widget mainBody() {
    return  Container(
      decoration: Provider.of<AppSettings>(context).isDarkMode ? BoxDecoration() : BoxDecoration(color: Colors.orange[100]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          topPanel(),
          songViewer(),
        ],
      ),
    );
  }

  Widget topPanel() {
    String songtitle = song.number.toString() + ". " + refineTitle(song.title);

    if (song.alias.length > 2 && song.title != song.alias) songtitle = songtitle + "\n" + refineTitle(song.alias);

    return Container(
      padding: const EdgeInsets.all(10),
      height: 80,
      child: Center(
        child: Text(
          songtitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25, 
            color: Provider.of<AppSettings>(context).isDarkMode ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  Widget songViewer() {
    return Container(
      height: MediaQuery.of(context).size.height - 170,
      decoration: Provider.of<AppSettings>(context).isDarkMode ? BoxDecoration() : BoxDecoration(color: Colors.orange[100]),
      child: VerticalTabs(
        tabsWidth: 50,
        indicatorColor: Provider.of<AppSettings>(context).isDarkMode ? Colors.white : Colors.deepOrange,
        indicatorWidth: 7,
        tabsElevation: 5,
        contentScrollAxis: Axis.vertical,
        tabs: List<Tab>.generate(
          verseInfos.length,
          (int index) {
            return Tab(
              child: Center(
                child: Text(verseInfos[index],
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)
                ),
              ),
            );
          },
        ),
        contents: List<Widget>.generate(
          verseInfos.length,
          (int index) {
            return Container(
              child: tabsContent(index),
              decoration: Provider.of<AppSettings>(context).isDarkMode ? BoxDecoration() : BoxDecoration(color: Colors.orange[100]),
            );
          },
        ),
        ),
      );
  }

  double getFontSize(int characters, double height, double width) {
    height = height - 300;
    width = width - 100;
    return sqrt((height * width) / characters);
  }

  Widget tabsContent(int index) {
    String lyrics = verseTexts[index].replaceAll("\\n", "\n").replaceAll("''", "'");
    double nfontsize = getFontSize(lyrics.length, MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);
    
    File image;
    
    //Create an instance of ScreenshotController
    ScreenshotController controller = ScreenshotController();

    return Stack(
      children: <Widget>[
        verseText(lyrics, nfontsize, image, controller),
        verseTitle(verseTitles[index]),
        Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height - 250, left: 15),
          child: Row(
            children: [
              copyVerse(index, lyrics),
              shareVerse(index, lyrics),
              imageVerse(index, lyrics, image, controller),
            ]
          ),
        ),
      ],
    );
  }

  Widget verseTitle(String verseTitle)
  {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        margin: EdgeInsets.only(top: 10, left: 10),
        child: Column(
          children: <Widget>[
            Container(
              width: 200,
              height: 50,
              decoration: BoxDecoration( color: Provider.of<AppSettings>(context).isDarkMode ? Colors.black : Colors.orange,
                border: Border.all(color: Colors.white),
                boxShadow: [BoxShadow(blurRadius: 5)],
                borderRadius: BorderRadius.all(Radius.circular(5))
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

  Widget verseText(String lyrics, double fontsize, File _imageFile, ScreenshotController screenshotController)
  {
    return Stack(
      children: <Widget>[
        Screenshot(
          controller: screenshotController,
          child: Container(
            height: MediaQuery.of(context).size.height - 275,
            margin: EdgeInsets.only(top: 25),
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            decoration: Provider.of<AppSettings>(context).isDarkMode ? BoxDecoration() : BoxDecoration(color: Colors.orange[100]),
            child: Card(
              elevation: 2,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    lyrics,
                    style: TextStyle(fontSize: fontsize),
                  ),
                ),
              )
            ),
          ),
        ),
        _imageFile != null ? Image.file(_imageFile) : Container(),
      ]
    );
  }

  Widget copyVerse(int index, String lyrics)
  {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: FloatingActionButton(
        heroTag: "CopyVerse_" + index.toString(),
        child: Icon(Icons.content_copy),
        tooltip: LangStrings.copyVerse,
        onPressed: () async {
          Clipboard.setData(ClipboardData(text: lyrics));
          globalKey.currentState.showSnackBar(SnackBar(
            content: Text(LangStrings.verseCopied),
          ));
        }
      ),
    );
  }

  
  Widget shareVerse(int index, String lyrics)
  {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: FloatingActionButton(
        heroTag: "ShareVerse_" + index.toString(),
        child: Icon(Icons.share),
        tooltip: LangStrings.shareVerse,
        onPressed: () async {
          Share.share(lyrics, subject: "Share a Verse of the song: " + songTitle);
        }
      ),
    );
  }

  Widget imageVerse(int index, String lyrics, File _imageFile, ScreenshotController screenshotController)
  {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: FloatingActionButton(
        heroTag: "ImageVerse_" + index.toString(),
        child: Icon(Icons.image),
        tooltip: LangStrings.imageVerse,
        onPressed: () {
          /*_incrementCounter();
          _imageFile = null;
          screenshotController.capture(delay: Duration(milliseconds: 10)).then((File image) async {
            //print("Capture Done");
            setState(() {
              _imageFile = image;
            });
            final result = await ImageGallerySaver.save(image.readAsBytesSync());
            print("File Saved to Gallery");
          }).catchError((onError) {
            print(onError);
          });*/
        },
      ),
    );
  }

  /*_saved(File image) async {
    final result = await ImageGallerySaver.save(image.readAsBytesSync());
    print("File Saved to Gallery");
  }*/

  List<Widget> floatingButtons() {
    return <Widget>[
      deleteButton(),
      FloatingActionButton(
        heroTag: null,
        child: Icon(Icons.content_copy),
        tooltip: LangStrings.copySong,
        onPressed: () async {
          Clipboard.setData(ClipboardData(text: songTitle + "\n\n" + songContent));
          globalKey.currentState.showSnackBar(SnackBar(
            content: Text(LangStrings.songCopied),
          ));
        }
      ),
      FloatingActionButton(
        heroTag: null,
        child: Icon(Icons.share),
        onPressed: () async {
          Share.share(songTitle + "\n\n" + songContent + "\n\nvia #vSongBook " + "https://Appsmata.com/vSongBook",
            subject: "Share the song: " + songTitle,
          );
        }
      ),
      FloatingActionButton(
        heroTag: null,
        child: Icon(Icons.edit),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) {
            return SongEdit(song, "Editting: " + songTitle);
          }));
        }
      ),
    ];
  }

  Widget deleteButton() {
    if (song.bookid == Columns.ownsongs)
      return FloatingActionButton(
        heroTag: null,
        child: Icon(Icons.delete),
        onPressed: () async {
          int result = await db.deleteSong(song.songid);
          if (result != 0) moveToLastScreen();
        }
      );
    else return null;
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

  void favoriteSong() {
    if (song.isfav == 1)
      db.favouriteSong(song, false);
    else
      db.favouriteSong(song, true);
    globalKey.currentState.showSnackBar(SnackBar(
      content: Text(songTitle + " " + LangStrings.songLiked),
    ));
    //notifyListeners();
  }

  Widget settingsDialog() {
    return AlertDialog(
      title: Text(LangStrings.quickSettings),
      content: Container(
        height: 150,
        width: double.maxFinite,
        child: ListView(children: <Widget>[
          Divider(),
          Consumer<AppSettings>(builder: (context, AppSettings settings, _) {
            return ListTile(
              onTap: () {},
              title: Text(LangStrings.darkMode),
              trailing: Switch(
                onChanged: (bool value) => settings.setDarkMode(value),
                value: settings.isDarkMode,
              ),
            );
          }),
          Consumer<AppSettings>(builder: (context, AppSettings settings, _) {
            return ListTile(
              onTap: () {},
              title: Text(LangStrings.screenAwake),
              trailing: Switch(
                onChanged: (bool value) => settings.setScreenAwake(value),
                value: settings.isScreenAwake,
              ),
            );
          }),
          Divider(),
        ]),
      ),
      actions: <Widget>[
        Container(
          child: FlatButton(
            child: Text(LangStrings.okayDone, style: TextStyle(fontSize: 20)),
            color: Colors.deepOrange,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }

  void selectedMenu(int menu, BuildContext context) {
    switch (menu) {
      case 1:
        showDialog(
          context: context,
          builder: (BuildContext context) => settingsDialog()
        );
        break;

      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Preferences();
          })
        );
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Donate();
          })
        );
        break;
      case 4:
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return HelpDesk();
          })
        );
        break;
      case 5:
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return AboutApp();
          })
        );
        break;
    }
  }

  /// Go back to the screen before the current one
  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}
