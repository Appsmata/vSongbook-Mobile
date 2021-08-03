import 'dart:async';
import 'package:flutter/material.dart';

import '../../../services/app_futures.dart';
import '../../../data/base/event_object.dart';
import '../../../utils/preferences.dart';
import '../../../utils/api_utils.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/colors.dart';
import '../../../data/app_database.dart';
import '../../../data/callbacks/Song.dart';
import '../../../data/models/song_model.dart';
import '../../widgets/as_line_progress.dart';
import '../../widgets/as_informer.dart';
import '../../widgets/as_loader.dart';
import '../../widgets/alerts/alert.dart';
import '../../widgets/alerts/alert_button.dart';
import '../../widgets/alerts/alert_style.dart';
import '../app_start.dart';

class SongsLoad extends StatefulWidget {
  @override
  createState() => SongsLoadState();
}

class SongsLoadState extends State<SongsLoad> {
  final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  AsLoader loader = AsLoader.setUp(ColorUtils.primaryColor);
  AsLineProgress progress = AsLineProgress.setUp(
      0, Colors.black, ColorUtils.primaryColor, ColorUtils.secondaryColor);
  AsInformer informer = AsInformer.setUp(1, AppStrings.gettingReady,
      ColorUtils.primaryColor, Colors.transparent, Colors.white, 10);

  AppDatabase databaseHelper = AppDatabase();
  List<Song> songs = [];

  double mHeight, mWidth;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initBuild(context));
  }

  /// Method to run anything that needs to be run immediately after Widget build
  void initBuild(BuildContext context) async {
    loader.showWidget();
    informer.show();
    requestData();
  }

  // Method to request data either from the db or server
  void requestData() async {
    String books = await Preferences.getSharedPreferenceStr(
        SharedPreferenceKeys.selectedBooks);

    EventObject eventObject = await getSongs(books);

    if (mounted) {
      setState(() {
        switch (eventObject.id) {
          case EventConstants.requestSuccessful:
            songs = [];
            songs = Song.fromData(eventObject.object);
            goToNextScreen();
            break;

          case EventConstants.requestUnsuccessful:
            Alert(
              context: context,
              alertTitle: AppStrings.areYouConnected,
              alertMessage: AppStrings.noConnection,
              style: AlertStyle(alertHeight: 150),
              buttons: [
                AlertButton(
                  text: AppStrings.okayGotIt,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ).show();
            informer.hide();
            break;

          case EventConstants.noInternetConnection:
            Alert(
              context: context,
              alertTitle: AppStrings.areYouConnected,
              alertMessage: AppStrings.noConnection,
              style: AlertStyle(alertHeight: 150),
              buttons: [
                AlertButton(
                  text: AppStrings.okayGotIt,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ).show();
            informer.hide();
            break;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      body: mainBody(),
    );
  }

  Widget mainBody() {
    mHeight = MediaQuery.of(context).size.height;
    mWidth = MediaQuery.of(context).size.width;

    return Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/bg.jpg"), fit: BoxFit.cover)),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            appIconLoader(),
            Container(
              margin: EdgeInsets.only(top: mHeight / 15.12),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Center(
                child: informer,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: mHeight / 30.24),
              width: mWidth / 1.125,
              child: Center(
                child: progress,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget appIconLoader() {
    return Stack(
      children: <Widget>[
        Center(
          child: Container(
            margin: EdgeInsets.only(top: mHeight / 6.3),
            child: Image(
              image: AssetImage("assets/images/appicon.png"),
              width: mWidth / 1.125,
            ),
          ),
        ),
        Center(
          child: Container(
            margin: EdgeInsets.only(top: mHeight / 5.21),
            child: loader,
          ),
        ),
      ],
    );
  }

  /// Save the data selected to the db
  Future<void> saveData() async {
    AppDatabase db = AppDatabase();

    for (int i = 0; i < songs.length; i++) {
      int progressValue = (i / songs.length * 100).toInt();
      progress.setProgress(progressValue);

      switch (progressValue) {
        case 1:
          informer.setText("On your marks ...");
          break;
        case 5:
          informer.setText("Set, Ready ...");
          break;
        case 10:
          informer.setText("Loading songs ...");
          break;
        case 20:
          informer.setText("Patience pays ...");
          break;
        case 40:
          informer.setText("Loading songs ...");
          break;
        case 75:
          informer.setText("Thanks for your patience!");
          break;
        case 85:
          informer.setText("Finishing up");
          break;
        case 95:
          informer.setText("Almost done");
          break;
      }

      Song item = songs[i];
      int itemid = int.parse(item.postid);
      int bookid = item.categoryid == null ? 1 : int.parse(item.categoryid);
      int number = item.number == null ? 0 : int.parse(item.number);
      int userid = item.userid == null ? 0 : int.parse(item.userid);

      String title = item.title.replaceAll("\n", "\\n").replaceAll("'", "''");
      String alias = item.alias.replaceAll("\n", "\\n").replaceAll("'", "''");
      String content =
          item.content.replaceAll("\n", "\\n").replaceAll("'", "''");

      SongModel song = SongModel(itemid, bookid, "S", number, title, alias,
          content, "", "", userid, item.created);
      await db.insertSong(song);
    }
  }

  /// Proceed to a newer screen
  Future<void> goToNextScreen() async {
    await saveData();
    Preferences.setSongsLoaded(true);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => AppStart()));
  }
}
