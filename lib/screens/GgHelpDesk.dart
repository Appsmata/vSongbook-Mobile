import 'package:flutter/material.dart';
import 'package:backdrop/backdrop.dart';
import 'package:vsongbook/screens/FfSettingsQuick.dart';
import 'package:vertical_tabs/vertical_tabs.dart';
import 'package:vsongbook/utils/Constants.dart';

class GgHelpDesk extends StatefulWidget {
  @override
  createState() => new GgHelpDeskState();
}

class GgHelpDeskState extends State<GgHelpDesk> {
  final globalKey = new GlobalKey<ScaffoldState>();
  List<String> titles, details, images;


 Future<void> setContent() async {
  titles = [];
  details = [];
  images = [];

  titles.add("Support");
  titles.add("App Reviews");
  titles.add("Open Source");

  images.add("support");
  images.add("review");
  images.add("github");

  details.add("PHONE: +2547 -\nEMAIL: appsmatake [at] gmail.com\nWebiste: https://Appsmata.com/vSongBook");
  details.add("Whether you are happy with our app or not please let us know by leaving a rating as well as review on the Google Play Store or Apple Store.");
  details.add("If you are a software developer, the source code for this app is freely available on the GitHub:\n\n Https://GitHub.com/Appsmata/vSongFlut");

 }

@override
  Widget build(BuildContext context) {

    if (titles == null) {
      titles = List<String>();
      details = List<String>();
      images = List<String>();
      setContent();
    }

    return WillPopScope(
      onWillPop: () {
        moveToLastScreen();
      },
      child: BackdropScaffold(
        title: Text('Help & Feedback'),
        iconPosition: BackdropIconPosition.action,
        headerHeight: 120,
        frontLayer: Center(
          child: Container(
            constraints: BoxConstraints.expand(),
            child: Scaffold(
              key: globalKey,
              body: Center(
                child: Container(
                  constraints: BoxConstraints.expand(),
                  child: bodyView(),
                ),
              ),
            ),
          ),
        ),
        backLayer: FfSettingsQuick(),
      ),
    );
  }

  Widget bodyView() {
    return VerticalTabs(
        tabsWidth: 100,
        contentScrollAxis: Axis.vertical,
        tabs: List<Tab>.generate(
          titles.length,
          (int index) {
            return new Tab(child: Text(titles[index], style: new TextStyle(fontSize: 20),));
          },
        ),
        contents: List<Widget>.generate( titles.length,
           (int index) {
            return new Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: new AssetImage("assets/images/bg.jpg"),
                    fit: BoxFit.cover
                )
              ),
              child: new Container(
                height: MediaQuery.of(context).size.height - 180,
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Card(
                  elevation: 5,
                  child: new Column(
                    children: <Widget>[
                      Image(
                        image: new AssetImage("assets/images/" + images[index] + ".png"),                          
                        height: 150.0,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),                        
                        child: Text(
                          details[index],
                          style: new TextStyle(fontSize: 30),
                        ),
                      )
                    ],
                  ),
                )
              ),
            );
          },
        )
      );
  }
  
  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}
