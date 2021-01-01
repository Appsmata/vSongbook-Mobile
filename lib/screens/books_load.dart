import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vsongbook/helpers/app_settings.dart';
import 'package:vsongbook/models/book_model.dart';
import 'package:vsongbook/widgets/as_progress.dart';
import 'package:vsongbook/helpers/app_futures.dart';
import 'package:vsongbook/models/base/event_object.dart';
import 'package:vsongbook/models/callbacks/Book.dart';
import 'package:vsongbook/utils/preferences.dart';
import 'package:vsongbook/utils/constants.dart';
import 'package:vsongbook/utils/colors.dart';
import 'package:vsongbook/helpers/app_database.dart';
import 'package:vsongbook/screens/songs_load.dart';
import 'package:vsongbook/screens/about_app.dart';
import 'package:vsongbook/screens/donate.dart';
import 'package:vsongbook/screens/help_desk.dart';

class BooksLoad extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return BooksLoadState();
  }
}

class BooksLoadState extends State<BooksLoad> {
  var appBar = AppBar();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AsProgress progress = AsProgress.getAsProgress(LangStrings.fetchingData);

  AppDatabase databaseHelper = AppDatabase();
  List<BookItem<Book>> selected = [];
  List<BookItem<Book>> bookList;
  List<Book> books = List<Book>();

  bool darkModePressed = false;

  BooksLoadState();
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => requestData(context));
  }

  void requestData(BuildContext context) async {
    progress.showProgress();

    EventObject eventObject = await getSongbooks();

    switch (eventObject.id) {
      case EventConstants.requestSuccessful:
        {
          setState(() {
            showDialog(
                context: context,
                builder: (context) => justAMinuteDialog());
            progress.hideProgress();
            books = eventObject.object;
            bookList = [];
            for (int i = 0; i < books.length; i++)
              bookList.add(BookItem<Book>(books[i]));
          });
        }
        break;

      case EventConstants.requestUnsuccessful:
        {
          setState(() {
            showDialog(
                context: context,
                builder: (context) => noInternetDialog());
            progress.hideProgress();
          });
        }
        break;

      case EventConstants.noInternetConnection:
        {
          setState(() {
            showDialog(
              context: context,
              builder: (context) => noInternetDialog()
            );
            progress.hideProgress();
          });
        }
        break;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LangStrings.setUpTheApp + LangStrings.appName),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => settingsDialog()
              );
            },
          ),
          menuPopup(),
        ],
      ),
      body: mainBody(),
    );
  }

  Widget mainBody() {
    return SingleChildScrollView(
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  LangStrings.createCollection,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                FlatButton(
                  child: Text(LangStrings.learnMore),
                  color: Colors.deepOrange,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => justAMinuteDialog()
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            height: (MediaQuery.of(context).size.height - (appBar.preferredSize.height * 2) - 50),
            padding: const EdgeInsets.symmetric(horizontal: 5),
            margin: EdgeInsets.only(top: 50),
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: books.length,
              itemBuilder: bookListView,
            ),
          ),
          Container(
            height: 100,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            margin: EdgeInsets.only(top: (MediaQuery.of(context).size.height - (appBar.preferredSize.height * 2) - 60)),
            child: Center(
              child: Container(
                width: 300,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: FloatingActionButton.extended(
                        heroTag: "reload",
                        icon: Icon(Icons.refresh, color: ColorUtils.white),
                        label: Text(LangStrings.reload, style: TextStyle(color: ColorUtils.white)),
                        onPressed: () {
                          books = List<Book>();
                          requestData(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: FloatingActionButton.extended(
                        heroTag: "proceed",
                        icon: Icon(Icons.check, color: ColorUtils.white),
                        label: Text(LangStrings.proceed, style: TextStyle(color: ColorUtils.white)),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => areYouDoneDialog()
                          );
                        },
                      ),
                    ),
                  ],
                )
              )
            ),
          ),
          Container(
            height: (MediaQuery.of(context).size.height - (appBar.preferredSize.height * 2)),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: progress,
          ),
        ],
      ),
    );
  }

  Widget menuPopup() => PopupMenuButton<int>(
    itemBuilder: (context) => [
      PopupMenuItem(
        value: 1,
        child: Text(LangStrings.supportUs),
      ),
      PopupMenuItem(
        value: 2,
        child: Text(LangStrings.helpFeedback),
      ),
      PopupMenuItem(
        value: 3,
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

  void selectedMenu(int menu, BuildContext context) {
    switch (menu) {
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Donate();
          })
        );
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return HelpDesk();
          })
        );
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return AboutApp();
          })
        );
        break;
    }
  }

  Widget settingsDialog() {
    return AlertDialog(
      title: new Text(
        LangStrings.displaySettings,
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
              title: Text(LangStrings.darkMode),
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
            Text(LangStrings.okayDone, style: new TextStyle(fontSize: 20)),
            color: Colors.deepOrange,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }

  Widget loadingGettingReady() {
    return Container(
      height: (MediaQuery.of(context).size.height - (appBar.preferredSize.height * 2)),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Stack(
        children: <Widget>[
          new Center(child: Container(width: 300, height: 120)),
          new Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                new CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation(Colors.deepOrange)),
                new Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Text(LangStrings.gettingReady,
                      style: new TextStyle(fontSize: 18)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget justAMinuteDialog() {
    return AlertDialog(
      title: new Text(
        LangStrings.justAMinute,
        style: new TextStyle(color: Colors.deepOrange, fontSize: 25),
      ),
      content: new Text(
        LangStrings.takeTimeSelecting,
        style: new TextStyle(fontSize: 20),
      ),
      actions: <Widget>[
        new Container(
          margin: EdgeInsets.all(5),
          child: FlatButton(
            child:
                Text(LangStrings.okayGotIt, style: new TextStyle(fontSize: 20)),
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

  Widget noInternetDialog() {
    return AlertDialog(
      title: new Text(
        LangStrings.areYouConnected,
        style: new TextStyle(color: Colors.deepOrange, fontSize: 25),
      ),
      content: new Text(
        LangStrings.noConnection,
        style: new TextStyle(fontSize: 20),
      ),
      actions: <Widget>[
        new Container(
          margin: EdgeInsets.all(5),
          child: FlatButton(
            child:
                Text(LangStrings.okayGotIt, style: new TextStyle(fontSize: 20)),
            color: Colors.deepOrange,
            textColor: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        Container(
          margin: EdgeInsets.all(5),
          child: FlatButton(
            child: Text(LangStrings.retry, style: new TextStyle(fontSize: 20)),
            color: Colors.deepOrange,
            textColor: Colors.white,
            onPressed: () {
              Navigator.pop(context);
              books = List<Book>();
              requestData(context);
            },
          ),
        ),
      ],
    );
  }

  Widget areYouDoneDialog() {
    if (selected.length > 0) {
      String selectedbooks = "";
      for (int i = 0; i < selected.length; i++) {
        selectedbooks = selectedbooks + (i + 1).toString() +  ". " +
            selected[i].data.title + " (" + selected[i].data.qcount + LangStrings.songsPrefix;
      }
      return AlertDialog(
        title: new Text(
          LangStrings.doneSelecting,
          style: new TextStyle(color: Colors.deepOrange, fontSize: 25),
        ),
        content: new Text(
          selectedbooks,
          style: new TextStyle(fontSize: 20),
        ),
        actions: <Widget>[
          new Container(
            margin: EdgeInsets.all(5),
            child: FlatButton(
              child:
                  Text(LangStrings.goBack, style: new TextStyle(fontSize: 20)),
              color: Colors.deepOrange,
              textColor: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          new Container(
            margin: EdgeInsets.all(5),
            child: FlatButton(
              child:
                  Text(LangStrings.proceed, style: new TextStyle(fontSize: 20)),
              color: Colors.deepOrange,
              textColor: Colors.white,
              onPressed: () {
                Navigator.pop(context);
                _goToNextScreen();
              },
            ),
          ),
        ],
      );
    } else {
      return AlertDialog(
        title: new Text(
          LangStrings.justAMinute,
          style: new TextStyle(color: Colors.orange, fontSize: 25),
        ),
        content: new Text(
          LangStrings.noSelection,
          style: new TextStyle(color: Colors.black, fontSize: 20),
        ),
        actions: <Widget>[
          new FlatButton(
            child: Text(LangStrings.okayGotIt,
                style: new TextStyle(color: Colors.orange, fontSize: 20)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    }
  }

  void onItemSelected(BookItem tapped) {
    setState(() {
      tapped.isSelected = !tapped.isSelected;
    });
    if (tapped.isSelected) {
      try {
        selected.add(tapped);
      } catch (Exception) {}
    } else {
      try {
        selected.remove(tapped);
      } catch (Exception) {}
    }
  }

  Widget bookListView(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        onItemSelected(bookList[index]);
      },
      onLongPress: () {
        onItemSelected(bookList[index]);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        child: Card(
          color: bookList[index].isSelected
              ? Colors.deepOrange
              : Provider.of<AppSettings>(context).isDarkMode
                  ? Colors.black
                  : Colors.white,
          elevation: 5,
          child: Row(
            children: <Widget>[
              Hero(
                tag: books[index].categoryid,
                child: Container(
                  height: 80,
                  width: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        topLeft: Radius.circular(5)),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: new AssetImage("assets/images/book.jpg")),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 5),
                height: 70,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      books[index].title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: bookList[index].isSelected ? Colors.white : Provider.of<AppSettings>(context).isDarkMode ? Colors.white : Colors.black
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(books[index].qcount + " " + books[index].backpath + LangStrings.songsInside + books[index].content,
                      style: TextStyle(
                        fontSize: 15,
                        color: bookList[index].isSelected ? Colors.white : Provider.of<AppSettings>(context).isDarkMode ? Colors.white : Colors.black
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveData() async {
    AppDatabase db = AppDatabase();

    for (int i = 0; i < selected.length; i++) {
      Book item = selected[i].data;
      int songs = int.parse(item.qcount);
      int cartid = int.parse(item.categoryid);
      BookModel book = new BookModel(cartid, 1, item.title, item.tags, songs,
          i + 1, item.content, item.backpath);
      await db.insertBook(book);
    }
  }

  void _goToNextScreen() {
    progress.showProgress();
    saveData();

    String selectedbooks = "";
    for (int i = 0; i < selected.length; i++)
      selectedbooks = selectedbooks + selected[i].data.categoryid + ",";

    try {
      selectedbooks = selectedbooks.substring(0, selectedbooks.length - 1);
    } catch (Exception) {}

    progress.hideProgress();
    Preferences.setBooksLoaded(true);
    Preferences.setSelectedBooks(selectedbooks);
    Navigator.pushReplacement(context,
        new MaterialPageRoute(builder: (context) => new SongsLoad()));
  }
}

class BookItem<T> {
  bool isSelected = false;
  T data;
  BookItem(this.data);
}
