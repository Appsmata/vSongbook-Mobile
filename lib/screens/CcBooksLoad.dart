import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vsongbook/helpers/AppSettings.dart';
import 'package:vsongbook/models/BookModel.dart';
import 'package:vsongbook/widgets/AsProgressDialog.dart';
import 'package:vsongbook/widgets/AsProgressWidget.dart';
import 'package:vsongbook/helpers/AppFutures.dart';
import 'package:vsongbook/models/base/EventObject.dart';
import 'package:vsongbook/models/callbacks/Book.dart';
import 'package:vsongbook/utils/Preferences.dart';
import 'package:vsongbook/utils/Constants.dart';
import 'package:vsongbook/helpers/SqliteHelper.dart';
import 'package:vsongbook/screens/CcSongsLoad.dart';

class CcBooksLoad extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CcBooksLoadState();
  }
}

class CcBooksLoadState extends State<CcBooksLoad> {
  var appBar = AppBar();
  final globalKey = new GlobalKey<ScaffoldState>();
  AsProgressDialog progressDialog =
      AsProgressDialog.getAsProgressDialog(LangStrings.Getting_Ready);
  AsProgressWidget progressWidget =
      AsProgressWidget.getProgressWidget(LangStrings.Getting_Ready);

  SqliteHelper databaseHelper = SqliteHelper();
  List<BookItem<Book>> selected = [];
  List<BookItem<Book>> bookList;
  List<Book> books;

  bool darkModePressed = false;

  void populateData() {
    bookList = [];
    for (int i = 0; i < books.length; i++)
      bookList.add(BookItem<Book>(books[i]));
  }

  void requestData() async {
    EventObject eventObject = await getSongbooks();

    switch (eventObject.id) {
      case EventConstants.Request_Successful:
        {
          setState(() {
            showDialog(
                context: context,
                builder: (BuildContext context) => justAMinuteDialog());
            progressWidget.hideProgress();
            books = eventObject.object;
            populateData();
          });
        }
        break;

      case EventConstants.Request_Unsuccessful:
        {
          setState(() {
            showDialog(
                context: context,
                builder: (BuildContext context) => noInternetDialog());
            progressWidget.hideProgress();
          });
        }
        break;

      case EventConstants.No_Internet_Connection:
        {
          setState(() {
            showDialog(
                context: context,
                builder: (BuildContext context) => noInternetDialog());
            progressWidget.hideProgress();
          });
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (books == null) {
      books = List<Book>();
      requestData();
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(LangStrings.SetUpvSongBook),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) => areYouDoneDialog());
        },
        tooltip: LangStrings.Proceed,
        child: Icon(Icons.check),
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
                  LangStrings.CreateCollection,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                FlatButton(
                  child: Text(LangStrings.LearnMore),
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
            child: progressWidget,
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
            child: progressDialog,
          ),
        ],
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

  Widget loadingGettingReady() {
    return new Container(
      height: (MediaQuery.of(context).size.height -
          (appBar.preferredSize.height * 2)),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: new Stack(
        children: <Widget>[
          new Center(child: new Container(width: 300, height: 120)),
          new Center(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                new CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation(Colors.deepOrange)),
                new Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: new Text(LangStrings.Getting_Ready,
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
    return new AlertDialog(
      title: new Text(
        LangStrings.JustAMinute,
        style: new TextStyle(color: Colors.deepOrange, fontSize: 25),
      ),
      content: new Text(
        LangStrings.TakeTimeSelectingSongbooks,
        style: new TextStyle(fontSize: 20),
      ),
      actions: <Widget>[
        new Container(
          margin: EdgeInsets.all(5),
          child: FlatButton(
            child:
                Text(LangStrings.OkayGotIt, style: new TextStyle(fontSize: 20)),
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
    return new AlertDialog(
      title: new Text(
        LangStrings.AreYouConnected,
        style: new TextStyle(color: Colors.deepOrange, fontSize: 25),
      ),
      content: new Text(
        LangStrings.NoConnection,
        style: new TextStyle(fontSize: 20),
      ),
      actions: <Widget>[
        new Container(
          margin: EdgeInsets.all(5),
          child: FlatButton(
            child:
                Text(LangStrings.OkayGotIt, style: new TextStyle(fontSize: 20)),
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
            child: Text(LangStrings.Retry, style: new TextStyle(fontSize: 20)),
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
    if (selected.length > 0) {
      String selectedbooks = "";
      for (int i = 0; i < selected.length; i++) {
        selectedbooks = selectedbooks +
            (i + 1).toString() +
            ". " +
            selected[i].data.title +
            " (" +
            selected[i].data.qcount +
            LangStrings.SongsPrefix;
      }
      return new AlertDialog(
        title: new Text(
          LangStrings.DoneSelecting,
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
                  Text(LangStrings.GoBack, style: new TextStyle(fontSize: 20)),
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
                  Text(LangStrings.Proceed, style: new TextStyle(fontSize: 20)),
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
      return new AlertDialog(
        title: new Text(
          LangStrings.JustAMinute,
          style: new TextStyle(color: Colors.orange, fontSize: 25),
        ),
        content: new Text(
          LangStrings.NoSelection,
          style: new TextStyle(color: Colors.black, fontSize: 20),
        ),
        actions: <Widget>[
          new FlatButton(
            child: new Text(LangStrings.OkayGotIt,
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
        //color: Colors.white,
        child: Card(
          //color: bookList[index].isSelected ? Colors.deepOrange : Colors.white,
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
                        image: new AssetImage("assets/images/book.jpg")),
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
                            LangStrings.SongsInside +
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
    SqliteHelper db = SqliteHelper();

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
    progressDialog.showProgress();
    saveData();

    String selectedbooks = "";
    for (int i = 0; i < selected.length; i++)
      selectedbooks = selectedbooks + selected[i].data.categoryid + ",";

    try {
      selectedbooks = selectedbooks.substring(0, selectedbooks.length - 1);
    } catch (Exception) {}

    progressDialog.hideProgress();
    Preferences.setBooksLoaded(true);
    Preferences.setSelectedBooks(selectedbooks);
    Navigator.pushReplacement(context,
        new MaterialPageRoute(builder: (context) => new CcSongsLoad()));
  }
}

class BookItem<T> {
  bool isSelected = false;
  T data;
  BookItem(this.data);
}
