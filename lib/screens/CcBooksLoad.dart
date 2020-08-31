import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vsongbook/helpers/AppSettings.dart';
import 'package:backdrop/backdrop.dart';
import 'package:vsongbook/models/BookModel.dart';
import 'package:vsongbook/widgets/AsProgressDialog.dart';
import 'package:vsongbook/widgets/AsProgressWidget.dart';
import 'package:vsongbook/helpers/AppFutures.dart';
import 'package:vsongbook/models/base/EventObject.dart';
import 'package:vsongbook/models/callbacks/Book.dart';
import 'package:vsongbook/utils/Preferences.dart';
import 'package:vsongbook/utils/constants.dart';
import 'package:vsongbook/helpers/SqliteHelper.dart';
import 'package:vsongbook/screens/CcSongsLoad.dart';
import 'package:vsongbook/screens/FfSettingsQuick.dart';

class CcBooksLoad extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CcBooksLoadState();
  }
}

class CcBooksLoadState extends State<CcBooksLoad> {
  var appBar = AppBar();
  final globalKey = new GlobalKey<ScaffoldState>();
  AsProgressDialog progressDialog = AsProgressDialog.getAsProgressDialog(AsProgressDialogTitles.Getting_Ready);
  AsProgressWidget progressWidget = AsProgressWidget.getProgressWidget(AsProgressDialogTitles.Getting_Ready);

  SqliteHelper databaseHelper = SqliteHelper();
  List<BookItem<Book>> selected = [];
  List<BookItem<Book>> bookList;
  List<Book> books;

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
              builder: (BuildContext context) => justAMinuteDialog()
            );
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
              builder: (BuildContext context) => noInternetDialog()
            );
            progressWidget.hideProgress();
          });
        }
        break;
      
      case EventConstants.No_Internet_Connection:
        {
          setState(() {
            showDialog(
              context: context,
              builder: (BuildContext context) => noInternetDialog()
            );
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

    return BackdropScaffold(
      title: Text('Set up your vSongBook'),
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
              builder: (BuildContext context) => areYouDoneDialog()
            );
          },
        ),
      ],
      iconPosition: BackdropIconPosition.action,
      headerHeight: 120,
      frontLayer: Center(
        child: Container(
          constraints: BoxConstraints.expand(),
          child: Scaffold(
            key: globalKey,
            body: mainBody(),
            floatingActionButton: FloatingActionButton(       
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => areYouDoneDialog()
                );
              },
              tooltip: 'Proceed',
              child: Icon(Icons.check),
            ),
          ),
        ),
      ),
      backLayer: FfSettingsQuick(),
    );

  }

  Widget mainBody()
  {
    return SingleChildScrollView(
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text( 'Create your Collection',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold ),
                ),
                FlatButton(
                  child: Text('Learn More'),
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
            height: (MediaQuery.of(context).size.height - (appBar.preferredSize.height * 2)),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: progressWidget,
          ),
          Container(
            height: (MediaQuery.of(context).size.height - (appBar.preferredSize.height * 2)),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            margin: EdgeInsets.only(top: 50),
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: books.length,
              itemBuilder: bookListView,
            ),
          ),
          Container(
            height: (MediaQuery.of(context).size.height - (appBar.preferredSize.height * 2)),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: progressDialog,
          ),
        ],
      ),
    );
  }

  Widget loadingGettingReady() 
  {
    return new Container(
      height: (MediaQuery.of(context).size.height - (appBar.preferredSize.height * 2)),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: new Stack(
        children: <Widget>[
            new Center( child: new Container( width: 300, height: 120 ) ),
            new Center(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  new CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation(Colors.deepOrange)),
                  new Container(
                    margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: new Text("Getting Ready ...", style: new TextStyle(fontSize: 18)),
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
        "Just a minute!",
        style: new TextStyle(color: Colors.deepOrange, fontSize: 25),
      ),
      content: new Text(
        "Take time to select a songbook at a time so as to setup your vSongBook Collection.\n\n" +
        "Once done that, proceed to press the 'TICK' button at the top right or bottom right for next stage\n\n" +
        "We can always bring you back here to add or remove songbooks",
        style: new TextStyle(fontSize: 20),
      ),
      actions: <Widget>[
        new Container(
          margin: EdgeInsets.all(5),
          child: FlatButton(
            child: Text('OKAY, GOT IT', style: new TextStyle(fontSize: 20)),
            color: Colors.deepOrange,
            //textColor: Colors.white,
            onPressed: () { Navigator.pop(context); },
          ),
        ),
      ],
    );
  }
  
  Widget noInternetDialog() {
    return new AlertDialog(
        title: new Text(
          "Wait, are you connected?",
          style: new TextStyle(color: Colors.deepOrange, fontSize: 25),
        ),
        content: new Text(
          "Oops! This is so heart breaking. You don't seem to have a working internet connection.\n\n" +
          "Kindly connect to a reliable internet either via Wi-Fi or Mobile Data then Retry again.",
          style: new TextStyle(fontSize: 20),
        ),
        actions: <Widget>[
          new Container(
            margin: EdgeInsets.all(5),
            child: FlatButton(
              child: Text('OKAY, GOT IT', style: new TextStyle(fontSize: 20)),
              color: Colors.deepOrange,
              textColor: Colors.white,
              onPressed: () { Navigator.pop(context); },
            ),
          ),
          new Container(
            margin: EdgeInsets.all(5),
            child: FlatButton(
              child: Text('RETRY', style: new TextStyle(fontSize: 20)),
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
    if (selected.length > 0)
    {
      String selectedbooks = "";
      for (int i = 0; i < selected.length; i++) 
      {
        selectedbooks = selectedbooks  + (i + 1).toString() + ". " + 
            selected[i].data.title + " (" + selected[i].data.qcount + " songs).\n";
      }
      return new AlertDialog(
        title: new Text(
          "Done with selecting?",
          style: new TextStyle(color: Colors.deepOrange, fontSize: 25),
        ),
        content: new Text(selectedbooks,
          style: new TextStyle(fontSize: 20),
        ),
        actions: <Widget>[
          new Container(
            margin: EdgeInsets.all(5),
            child: FlatButton(
              child: Text('GO BACK', style: new TextStyle(fontSize: 20)),
              color: Colors.deepOrange,
              textColor: Colors.white,
              onPressed: () { Navigator.pop(context); },
            ),
          ),
          new Container(
            margin: EdgeInsets.all(5),
            child: FlatButton(
              child: Text('PROCEED', style: new TextStyle(fontSize: 20)),
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
    }
    else
    {
      return new AlertDialog(
        title: new Text(
          "Just a Minute ...",
          style: new TextStyle(color: Colors.orange, fontSize: 25),
        ),
        content: new Text(
          "Oops! This is so heart breaking. You haven't selected a book, you expect things to be okay. You got to " +
          "select at least one book.\n\n By the way we can always bring you back here to select afresh. But for " +
          "now select at least one.",
          style: new TextStyle(color: Colors.black, fontSize: 20),
        ),
        actions: <Widget>[
          new FlatButton(
            child: new Text("Okay, Got it",
                style: new TextStyle(color: Colors.orange, fontSize: 20)),
            onPressed: () { Navigator.pop(context); },
          ),
        ],
      );
    }
  }

  void onItemSelected(BookItem tapped){
    setState(() { tapped.isSelected = !tapped.isSelected;  });
    if (tapped.isSelected)
    {
      try
      {
        selected.add(tapped);
      }
      catch (Exception) {}
    }
    else
    {
      try
      {
        selected.remove(tapped);
      }
      catch (Exception) {}
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
          color: bookList[index].isSelected ? Colors.deepOrange : Provider.of<AppSettings>(context).isDarkMode ? Colors.black : Colors.white,
          elevation: 5,
          child: Row(
              children: <Widget>[
                Hero(
                  tag: books[index].categoryid,
                  child: Container(
                    height: 120,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only( bottomLeft: Radius.circular(5), topLeft: Radius.circular(5)),
                      image: DecorationImage(fit: BoxFit.cover, image: new AssetImage("assets/images/book.jpg") ),
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
                          fontSize: 16, fontWeight: FontWeight.bold, 
                          color: bookList[index].isSelected ? Colors.white : Provider.of<AppSettings>(context).isDarkMode ? Colors.white : Colors.black
                        ), 
                      ),
                      SizedBox( height: 10 ),
                      Container(
                        width: 240,
                        child: Text( 
                          books[index].qcount + " " + books[index].backpath + " songs inside;\n" + books[index].content,
                          style: TextStyle(  
                            color: bookList[index].isSelected ? Colors.white : Provider.of<AppSettings>(context).isDarkMode ? Colors.white : Colors.black
                          ),
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

    for (int i = 0; i < selected.length; i++) 
    {
      Book item = selected[i].data;
      int songs = int.parse(item.qcount);
      int cartid = int.parse(item.categoryid);
      BookModel book = new BookModel(cartid, 1, item.title, item.tags, songs, i + 1, item.content, item.backpath);
      await db.insertBook(book);
    }
  }

  void _goToNextScreen() {
    progressDialog.showProgress();
    saveData();

    String selectedbooks = selected[0].data.categoryid;
    for (int i = 1; i < selected.length; i++){
      selectedbooks = selectedbooks  + "," + selected[i].data.categoryid;
    }
    
    progressDialog.hideProgress();
    Preferences.setBooksLoaded(true);
    Preferences.setSelectedBooks(selectedbooks);
    Navigator.pushReplacement( context, new MaterialPageRoute(builder: (context) => new CcSongsLoad()));  
  }

}

class BookItem<T> {
  bool isSelected = false;
  T data;
  BookItem(this.data);
}
