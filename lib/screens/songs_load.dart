import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vsongbook/helpers/app_settings.dart';
import 'package:vsongbook/models/song_model.dart';
import 'package:vsongbook/helpers/app_futures.dart';
import 'package:vsongbook/models/base/event_object.dart';
import 'package:vsongbook/models/callbacks/Song.dart';
import 'package:vsongbook/utils/preferences.dart';
import 'package:vsongbook/utils/constants.dart';
import 'package:vsongbook/helpers/app_database.dart';
import 'package:vsongbook/screens/app_start.dart';
import 'package:vsongbook/widgets/as_text_view.dart';
import 'package:vsongbook/widgets/as_line_progress.dart';

class SongsLoad extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SongsLoadState();
  }
}

class SongsLoadState extends State<SongsLoad> {
  AsTextView textIndicator = AsTextView.setUp(LangStrings.gettingReady, 25, true);
  AsTextView textProgress = AsTextView.setUp("", 25, true);
  AsLineProgress lineProgress = AsLineProgress.setUp(300, 0);
  final globalKey = new GlobalKey<ScaffoldState>();

  AppDatabase databaseHelper = AppDatabase();
  List<Song> songs;

  void requestData() async {
    String books = await Preferences.getSharedPreferenceStr(
        SharedPreferenceKeys.selectedBooks);
    EventObject eventObject = await getSongs(books);

    switch (eventObject.id) {
      case EventConstants.requestSuccessful:
        {
          setState(() {
            //globalKey.currentState.showSnackBar(new SnackBar(content: new Text(LangStrings.Request_Successful)));
            //progressDialog.hideProgress();
            songs = eventObject.object;
            _goToNextScreen();
          });
        }
        break;

      case EventConstants.requestUnsuccessful:
        {
          setState(() {
            //globalKey.currentState.showSnackBar(new SnackBar(content: new Text(LangStrings.Request_Unsuccessful)));
            //progressDialog.hideProgress();
          });
        }
        break;

      case EventConstants.noInternetConnection:
        {
          setState(() {
            //globalKey.currentState.showSnackBar(new SnackBar(content: new Text(LangStrings.No_Internet_Connection)));
            //progressDialog.hideProgress();
          });
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (songs == null) {
      songs = List<Song>();
      requestData();
    }

    return Scaffold(
      key: globalKey,
      body: Center(
        child: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: new AssetImage("assets/images/bg.jpg"),
                  fit: BoxFit.cover)),
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  _appIcon(),
                  _appLoading(),
                ],
              ),
              _appLabel(),
              Stack(
                children: <Widget>[
                  _appProgress(),
                  _appProgressText(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appIcon() {
    return Center(
      child: Container(
        child: Image(
          image: new AssetImage("assets/images/appicon.png"),
          height: 450,
          width: 300,
        ),
        margin: EdgeInsets.only(top: 75),
      ),
    );
  }

  Widget _appLoading() {
    return Center(
      child: Container(
        child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation(Colors.white)),
        margin: EdgeInsets.only(top: 200),
      ),
    );
  }

  Widget _appLabel() {
    return Center(
      child: Container(
        height: 100,
        width: 350,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: Provider.of<AppSettings>(context).isDarkMode
            ? BoxDecoration()
            : BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.orange),
                boxShadow: [BoxShadow(blurRadius: 5)],
                borderRadius: new BorderRadius.all(new Radius.circular(10))),
        child: Stack(
          children: <Widget>[
            new Center(child: Container(width: 300, height: 120)),
            new Center(
              child: Container(
                margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: textIndicator,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _appProgress() {
    return Center(
      child: Container(
        height: 100,
        width: 350,
        margin: EdgeInsets.only(top: 20),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Stack(
          children: <Widget>[
            new Center(
              child: lineProgress,
            )
          ],
        ),
      ),
    );
  }

  Widget _appProgressText() {
    return Center(
      child: Container(
        height: 100,
        width: 350,
        margin: EdgeInsets.only(top: 20),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Stack(
          children: <Widget>[
            new Center(
              child: textProgress,
            )
          ],
        ),
      ),
    );
  }

  Future<void> saveData() async {
    AppDatabase db = AppDatabase();

    for (int i = 0; i < songs.length; i++) {
      int progress = (i / songs.length * 100).toInt();
      String progresStr = (progress / 100).toStringAsFixed(1);

      textProgress.setText(progress.toString() + " %");
      lineProgress.setProgress(double.parse(progresStr));

      switch (progress) {
        case 1:
          textIndicator.setText("On your marks ...");
          break;
        case 5:
          textIndicator.setText("Set, Ready ...");
          break;
        case 10:
          textIndicator.setText("Loading songs ...");
          break;
        case 20:
          textIndicator.setText("Patience pays ...");
          break;
        case 40:
          textIndicator.setText("Loading songs ...");
          break;
        case 75:
          textIndicator.setText("Thanks for your patience!");
          break;
        case 85:
          textIndicator.setText("Finishing up");
          break;
        case 95:
          textIndicator.setText("Almost done");
          break;
      }

      Song item = songs[i];
      int itemid = int.parse(item.postid);
      int bookid = item.categoryid == null ? 1 : int.parse(item.categoryid);
      int number = item.number == null ? 0 : int.parse(item.number);
      int userid = item.userid == null ? 0 : int.parse(item.userid);

      String title = item.title.replaceAll("\n", "\\n").replaceAll("'", "''");
      String alias = item.title.replaceAll("\n", "\\n").replaceAll("'", "''");
      String content =
          item.content.replaceAll("\n", "\\n").replaceAll("'", "''");

      SongModel song = new SongModel(itemid, bookid, "S", number, title, alias,
          content, "", "", userid, item.created);
      await db.insertSong(song);
    }
  }

  Future<void> _goToNextScreen() async {
    await saveData();
    Preferences.setSongsLoaded(true);
    Navigator.pushReplacement(
        context, new MaterialPageRoute(builder: (context) => new AppStart()));
  }
}
