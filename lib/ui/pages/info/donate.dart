import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/app_settings.dart';
import '../../../utils/app_utils.dart';

class Donate extends StatefulWidget {
  @override
  createState() => DonateState();
}

class DonateState extends State<Donate> {
  final globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final tabPages = <Widget>[
      tabContent("donation1", AppStrings.donateTab1Content),
      tabContent("donation2", AppStrings.donateTab2Content),
      tabContent("donation3", AppStrings.donateTab3Content),
      tabContent("donation4", AppStrings.donateTab4Content),
    ];
    final tabTitles = <Tab>[
      Tab(text: AppStrings.donateTab1Title),
      Tab(text: AppStrings.donateTab2Title),
      Tab(text: AppStrings.donateTab3Title),
      Tab(text: AppStrings.donateTab4Title),
    ];

    return WillPopScope(
      onWillPop: () {
        moveToLastScreen();
      },
      child: DefaultTabController(
        length: tabTitles.length,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(AppStrings.donateTabPage),
            bottom: TabBar(
              tabs: tabTitles,
            ),
          ),
          body: TabBarView(
            children: tabPages,
          ),
        ),
      ),
    );
  }

  Widget tabContent(String image, String strText) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: Provider.of<AppSettings>(context).isDarkMode
          ? BoxDecoration()
          : BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, Colors.cyan, Colors.indigo]),
            ),
      child: ListView(
        children: <Widget>[
          Card(
            elevation: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Image(
                image: AssetImage("assets/images/" + image + ".png"),
              ),
            ),
          ),
          Card(
            elevation: 10,
            child: GestureDetector(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Text(
                  strText,
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Go back to the screen before the current one
  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}
