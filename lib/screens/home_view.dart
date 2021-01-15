import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'package:vsongbook/utils/colors.dart';
import 'package:vsongbook/utils/constants.dart';
import 'package:vsongbook/views/favorites.dart';
import 'package:vsongbook/views/song_list.dart';
import 'package:vsongbook/views/song_pad.dart';
import 'package:vsongbook/models/book_model.dart';
import 'package:vsongbook/models/song_model.dart';
import 'package:vsongbook/helpers/app_database.dart';
import 'package:vsongbook/helpers/app_search_delegate.dart';
import 'package:vsongbook/views/nav_drawer.dart';
import 'package:app_prompter/app_prompter.dart';

class HomeView extends StatefulWidget {
  HomeView();

  @override
  createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  HomeViewState();
  NavDrawer navDrawer;

  WidgetBuilder builder = buildProgressIndicator;

  AppPrompter appPrompter = AppPrompter(
    preferencesPrefix: 'appPrompter_',
    minDays: 0,
    minLaunches: 3,
    remindDays: 2,
    remindLaunches: 3
  );


  AppDatabase db = AppDatabase();
  List<BookModel> bookList = List<BookModel>();
  List<SongModel> songList = List<SongModel>();
  String searchStr = '';
	int count = 0;
  
  bool _hasSpeech = false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastWords = '';
  String lastError = '';
  String lastStatus = '';
  String _currentLocaleId = '';
  int resultListened = 0;
  List<LocaleName> _localeNames = [];
  final SpeechToText speech = SpeechToText();


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => updateBookList(context));
  }

  Future<void> initSpeechState() async {
    var hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener, debugLogging: true);
    if (hasSpeech) {
      _localeNames = await speech.locales();

      var systemLocale = await speech.systemLocale();
      _currentLocaleId = systemLocale.localeId;
    }

    if (!mounted) return;

    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  void startListening() {
    lastWords = '';
    lastError = '';
    speech.listen(
        onResult: resultListener,
        listenFor: Duration(seconds: 5),
        pauseFor: Duration(seconds: 5),
        partialResults: false,
        localeId: _currentLocaleId,
        onSoundLevelChange: soundLevelListener,
        cancelOnError: true,
        listenMode: ListenMode.confirmation);
    setState(() { });
  }

  void stopListening() async {
    speech.stop();
    setState(() {
      level = 0.0;
    });
  }

  void cancelListening() {
    speech.cancel();
    setState(() {
      level = 0.0;
    });
  }

  void resultListener(SpeechRecognitionResult result) {
    ++resultListened;
    print('Result listener $resultListened');
    setState(() {
      lastWords = '${result.recognizedWords} - ${result.finalResult}';
      searchStr = lastWords;
    });
    
    showSearch(
      context: context,
      delegate: AppSearchDelegate(context, bookList, songList, searchStr),
    );
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    // print("sound level $level: $minSoundLevel - $maxSoundLevel ");
    setState(() {
      this.level = level;
    });
  }

  void errorListener(SpeechRecognitionError error) {
    // print("Received error status: $error, listening: ${speech.isListening}");
    setState(() {
      lastError = '${error.errorMsg} - ${error.permanent}';
    });
  }

  void statusListener(String status) {
    // print(
    // 'Received listener status: $status, listening: ${speech.isListening}');
    setState(() {
      lastStatus = '$status';
    });
  }

  void _switchLang(selectedVal) {
    setState(() {
      _currentLocaleId = selectedVal;
    });
    print(selectedVal);
  }

  void updateBookList(BuildContext context) {
    final Future<Database> dbFuture = db.initializeDatabase();
    dbFuture.then((database) {
      Future<List<BookModel>> bookListFuture = db.getBookList();
      bookListFuture.then((bookList) {
        setState(() {
          this.bookList = bookList;
          updateSongList();
        });
      });
    });
  }

  void updateSongList() {
    final Future<Database> dbFuture = db.initializeDatabase();
    dbFuture.then((database) {
      Future<List<SongModel>> songListFuture = db.getSongList(0);
      songListFuture.then((songList) {
        setState(() {
          this.songList = songList;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SongList home = SongList(bookList);
    Favorites likes = Favorites(bookList);
    SongPad drafts = SongPad(bookList);
    
    final appPages = <Widget>[
      Center(child: home),
      Center(child: likes),
      Center(child: drafts),
    ];

    final appTabs = <Tab>[
      Tab(text: 'HOME'),
      Tab(text: 'LIKES'),
      Tab(text: 'DRAFTS'),
    ];

    if (navDrawer == null) navDrawer = NavDrawer();

    return DefaultTabController(
      length: appTabs.length,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          iconTheme: IconThemeData(color: ColorUtils.white),
          title: const Text(LangStrings.appName),
          centerTitle: true,
          bottom: TabBar(tabs: appTabs),
          actions: <Widget>[
            IconButton(
              tooltip: LangStrings.searchNow,
              icon: const Icon(Icons.search),
              onPressed: () async {
                final List selected = await showSearch(
                  context: context,
                  delegate: AppSearchDelegate(context, bookList, songList, searchStr),
                );
              },
            ),
            IconButton(
              tooltip: LangStrings.searchNow,
              icon: const Icon(Icons.mic),
              onPressed: () async {
                !_hasSpeech || speech.isListening ? null : startListening;
              },
            ),
          ],
        ),
        body: Stack(              
            children: <Widget>[
              TabBarView(children: appPages),
              AppPrompterBuilder(
                builder: builder,
                onInitialized: (context, appPrompter) {                    
                  if (appPrompter.shouldOpenDialog) {
                    appPrompter.showPromptDialog(
                      context,
                      title: LangStrings.donateDialogTitle, // The dialog title.
                      message: LangStrings.donateDialogMessage, // The dialog message.
                      actionButton: LangStrings.donateActionButton, // The dialog "action" button text.
                      noButton: "", // The dialog "no" button text.
                      laterButton: LangStrings.laterActionButton, // The dialog "later" button text.
                      listener: (button) { // The button click listener (useful if you want to cancel the click event).
                        switch(button) {
                          case AppPrompterDialogButton.action:
                            //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Donate()));
                            //break;
                          case AppPrompterDialogButton.action:
                          case AppPrompterDialogButton.later:
                          case AppPrompterDialogButton.no:
                            //print('Clicked on "Later".');
                            break;
                        }
                        
                        return true; // Return false if you want to cancel the click event.
                      },
                      dialogStyle: DialogStyle(), // Custom dialog styles.
                      onDismissed: () => appPrompter.callEvent(AppPrompterEventType.laterButtonPressed),
                    );
                  }
                },
              ),
            ]
          ),
        drawer: Drawer(child: navDrawer),
      ),
    );
  }
  static Widget buildProgressIndicator(BuildContext context) => const Center();
}
