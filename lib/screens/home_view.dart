import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vsongbook/screens/donate.dart';
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

  @override
  createState() => new HomeViewState();
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
	int count = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => updateBookList(context));
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
          iconTheme: new IconThemeData(color: ColorUtils.white),
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
                  delegate: AppSearchDelegate(context, bookList, songList),
                );
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
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return Donate();
                              })
                            );
                            break;
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
