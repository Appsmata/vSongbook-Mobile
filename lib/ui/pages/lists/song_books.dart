import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/app_settings.dart';
import '../../../data/models/list_item.dart';
import '../../../data/models/book_model.dart';
import '../../../services/app_futures.dart';
import '../../../data/base/event_object.dart';
import '../../../data/callbacks/Book.dart';
import '../../../data/app_database.dart';
import '../../../utils/colors.dart';
import '../../../utils/api_utils.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/preferences.dart';
import '../../widgets/as_informer.dart';
import '../app_start.dart';

class SongBooks extends StatefulWidget {
  SongBooks();

  @override
  createState() => SongBooksState();
}

class SongBooksState extends State<SongBooks> {
  final globalKey = GlobalKey<ScaffoldState>();

  var appBar = AppBar();

  AsInformer progress = AsInformer.setUp(1, AppStrings.fetchingData,
      ColorUtils.primaryColor, Colors.white, Colors.transparent, 10);

  AppDatabase db = AppDatabase();
  Future<Database> dbFuture;
  List<ListItem<Book>> selected = [], bookList;
  List<BookModel> mybooks;
  List<Book> books;
  String backpathStr = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initBuild(context));
  }

  /// Method to run anything that needs to be run immediately after Widget build
  void initBuild(BuildContext context) async {
    requestData();
  }

  void populateData() {
    bookList = [];
    for (int i = 0; i < books.length; i++) {
      bookList.add(ListItem<Book>(books[i]));
    }

    for (int i = 0; i < books.length; i++) {
      if (backpathStr.length > 1) {
        bookList[i].isSelected =
            backpathStr.contains(bookList[i].data.backpath) ? true : false;
      }
    }
  }

  void updateBookList() async {
    dbFuture = db.initializeDatabase();
    dbFuture.then((database) {
      Future<List<BookModel>> bookListFuture = db.getBookList();
      bookListFuture.then((mybookList) {
        setState(() {
          mybooks = mybookList;
        });

        for (int i = 0; i < mybooks.length; i++) {
          backpathStr = backpathStr + mybooks[i].backpath + ",";
        }
      });
    });
    requestData();
  }

  /// Method to request data either from the db or server
  void requestData() async {
    EventObject eventObject = await getSongbooks();

    switch (eventObject.id) {
      case EventConstants.requestSuccessful:
        {
          setState(() {
            showDialog(
                context: context,
                builder: (BuildContext context) => justAMinuteDialog());
            progress.hide();
            books = eventObject.object;
            populateData();
          });
        }
        break;

      case EventConstants.requestUnsuccessful:
        {
          setState(() {
            showDialog(
                context: context,
                builder: (BuildContext context) => noInternetDialog());
            progress.hide();
          });
        }
        break;

      case EventConstants.noInternetConnection:
        {
          setState(() {
            showDialog(
                context: context,
                builder: (BuildContext context) => noInternetDialog());
            progress.hide();
          });
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (books == null) {
      books = List<Book>();
      mybooks = [];
      updateBookList();
    }

    return WillPopScope(
      onWillPop: () {
        moveToLastScreen();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.setUpTheApp),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                books = List<Book>();
                requestData();
              },
            ),
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => areYouDoneDialog());
              },
            ),
          ],
        ),
        body: mainBody(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) => areYouDoneDialog());
          },
          tooltip: AppStrings.proceed,
          child: Icon(Icons.check),
        ),
      ),
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
                  AppStrings.createCollection,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                FlatButton(
                  child: Text(AppStrings.learnMore),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => justAMinuteDialog());
                  },
                ),
              ],
            ),
          ),
          Container(
            height: (MediaQuery.of(context).size.height -
                (appBar.preferredSize.height * 2)),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            margin: EdgeInsets.only(top: 50),
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: books.length,
              itemBuilder: bookListView,
            ),
          ),
          Container(
            height: (MediaQuery.of(context).size.height -
                (appBar.preferredSize.height * 2)),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: progress,
          ),
        ],
      ),
    );
  }

  Widget loadingGettingReady() {
    return Container(
      height: (MediaQuery.of(context).size.height -
          (appBar.preferredSize.height * 2)),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Stack(
        children: <Widget>[
          Center(child: Container(width: 300, height: 120)),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.deepOrange)),
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Text(AppStrings.gettingReady,
                      style: TextStyle(fontSize: 18)),
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
      title: Text(
        AppStrings.justAMinute,
        style: TextStyle(color: Colors.deepOrange, fontSize: 25),
      ),
      content: Text(
        AppStrings.takeTimeSelecting,
        style: TextStyle(fontSize: 20),
      ),
      actions: <Widget>[
        Container(
          margin: EdgeInsets.all(5),
          child: FlatButton(
            child: Text(AppStrings.okayGotIt, style: TextStyle(fontSize: 20)),
            color: Colors.deepOrange,
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
      title: Text(
        AppStrings.areYouConnected,
        style: TextStyle(color: Colors.deepOrange, fontSize: 25),
      ),
      content: Text(
        AppStrings.noConnection,
        style: TextStyle(fontSize: 20),
      ),
      actions: <Widget>[
        Container(
          margin: EdgeInsets.all(5),
          child: FlatButton(
            child: Text(AppStrings.okayGotIt, style: TextStyle(fontSize: 20)),
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
            child: Text(AppStrings.retry, style: TextStyle(fontSize: 20)),
            color: Colors.deepOrange,
            textColor: Colors.white,
            onPressed: () {
              Navigator.pop(context);
              books = List<Book>();
              requestData();
            },
          ),
        ),
      ],
    );
  }

  Widget areYouDoneDialog() {
    String selectedbooks = "";
    for (int i = 0; i < bookList.length; i++) {
      if (bookList[i].isSelected) {
        selectedbooks = selectedbooks +
            (i + 1).toString() +
            ". " +
            bookList[i].data.title +
            " (" +
            bookList[i].data.qcount +
            AppStrings.songsPrefix;
      }
    }
    return AlertDialog(
      title: Text(
        AppStrings.doneSelecting,
        style: TextStyle(color: Colors.deepOrange, fontSize: 25),
      ),
      content: Text(
        selectedbooks,
        style: TextStyle(fontSize: 20),
      ),
      actions: <Widget>[
        Container(
          margin: EdgeInsets.all(5),
          child: FlatButton(
            child: Text(AppStrings.goBack, style: TextStyle(fontSize: 20)),
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
            child: Text(AppStrings.proceed, style: TextStyle(fontSize: 20)),
            color: Colors.deepOrange,
            textColor: Colors.white,
            onPressed: () {
              Navigator.pop(context);
              goToNextScreen();
            },
          ),
        ),
      ],
    );
  }

  void onItemSelected(ListItem tapped) {
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
                  height: 120,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        topLeft: Radius.circular(5)),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/images/book.jpg")),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                height: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      books[index].title,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: bookList[index].isSelected
                              ? Colors.white
                              : Provider.of<AppSettings>(context).isDarkMode
                                  ? Colors.white
                                  : Colors.black),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: 240,
                      child: Text(
                        books[index].qcount +
                            " " +
                            books[index].backpath +
                            AppStrings.songsInside +
                            books[index].content,
                        style: TextStyle(
                            color: bookList[index].isSelected
                                ? Colors.white
                                : Provider.of<AppSettings>(context).isDarkMode
                                    ? Colors.white
                                    : Colors.black),
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
    String selectedbooks = "";

    for (int i = 0; i < selected.length; i++) {
      Book item = selected[i].data;
      int songs = int.parse(item.qcount);
      int cartid = int.parse(item.categoryid);
      BookModel book = BookModel(cartid, 1, item.title, item.tags, songs, i + 1,
          item.content, item.backpath);

      if (backpathStr.length > 1) {
        if (backpathStr.contains(selected[i].data.backpath))
          await db.deleteBook(book.bookid);
        else {
          await db.insertBook(book);
          selectedbooks = selectedbooks + selected[i].data.categoryid + ",";
        }
      } else {
        await db.insertBook(book);
        selectedbooks = selectedbooks + selected[i].data.categoryid + ",";
      }

      try {
        selectedbooks = selectedbooks.substring(0, selectedbooks.length - 1);
      } catch (Exception) {}

      print(selectedbooks);
      Preferences.setBooksLoaded(true);
      Preferences.setSelectedBooks(selectedbooks);
      Preferences.setSongsLoaded(false);
    }
  }

  /// Proceed to a newer screen
  void goToNextScreen() {
    progress.show();
    saveData();

    progress.hide();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => AppStart()));
  }

  /// Go back to the screen before the current one
  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}
