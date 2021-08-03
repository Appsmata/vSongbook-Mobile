import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../services/app_settings.dart';
import '../../../data/app_database.dart';
import '../../../data/models/song_model.dart';
import '../../../utils/app_utils.dart';

class SongEdit extends StatefulWidget {
  final String appBarTitle;
  final SongModel song;

  SongEdit(this.song, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return SongEditState(this.song, this.appBarTitle);
  }
}

class SongEditState extends State<SongEdit> {
  AppDatabase db = AppDatabase();

  String appBarTitle;
  SongModel song;

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController keyController = TextEditingController();
  TextEditingController aliasController = TextEditingController();

  SongEditState(this.song, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    titleController.text = song.title;
    contentController.text =
        song.content.replaceAll("\\n", "\n").replaceAll("''", "'");
    keyController.text = song.key;
    aliasController.text = song.alias;

    return WillPopScope(
      onWillPop: () {
        moveToLastScreen();
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(appBarTitle),
          leading: IconButton(
              icon: Icon(Icons.arrow_back), onPressed: moveToLastScreen),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.check), onPressed: saveSong),
            IconButton(icon: Icon(Icons.clear), onPressed: moveToLastScreen)
          ],
        ),
        body: mainBody(),
      ),
    );
  }

  Widget mainBody() {
    return Container(
      constraints: BoxConstraints.expand(),
      decoration: Provider.of<AppSettings>(context).isDarkMode
          ? BoxDecoration()
          : BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/bg.jpg"),
                  fit: BoxFit.cover)),
      child: ListView(
        padding: EdgeInsets.all(8.0),
        children: <Widget>[
          basicForm(),
          extraForm(),
        ],
      ),
    );
  }

  Widget basicForm() {
    return Card(
      elevation: 2,
      child: Center(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 0),
                child: TextField(
                  style: TextStyle(fontSize: 25),
                  controller: titleController,
                  onChanged: (value) {
                    updateTitle();
                  },
                  decoration: InputDecoration(
                      labelText: AppStrings.songTitle,
                      hintText: AppStrings.songTitle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: TextFormField(
                  style: TextStyle(fontSize: 25),
                  controller: contentController,
                  onChanged: (value) {
                    updateContent();
                  },
                  decoration: InputDecoration(
                      labelText: AppStrings.songContent,
                      hintText: AppStrings.songContent,
                      //helperText: AppStrings.SongContent,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                  maxLines: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget extraForm() {
    return Card(
      elevation: 2,
      child: Center(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 0),
                child: Text(
                  "Extra Details (Optional)",
                  style: TextStyle(fontSize: 25),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: TextField(
                  style: TextStyle(fontSize: 20),
                  controller: keyController,
                  onChanged: (value) {
                    updateKey();
                  },
                  decoration: InputDecoration(
                      labelText: AppStrings.songKey,
                      hintText: AppStrings.songKey,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: TextFormField(
                  style: TextStyle(fontSize: 20),
                  controller: aliasController,
                  onChanged: (value) {
                    updateContent();
                  },
                  decoration: InputDecoration(
                      labelText: AppStrings.songNotes,
                      hintText: AppStrings.songNotes,
                      //helperText: AppStrings.SongContent,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                  maxLines: 3,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: TextField(
                  style: TextStyle(fontSize: 20),
                  controller: aliasController,
                  onChanged: (value) {
                    updateAlias();
                  },
                  decoration: InputDecoration(
                      labelText: AppStrings.songNotes,
                      hintText: AppStrings.songNotes,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateTitle() {
    song.title = titleController.text;
  }

  void updateContent() {
    song.content = contentController.text;
  }

  void updateKey() {
    song.key = keyController.text;
  }

  void updateAlias() {
    song.alias = aliasController.text;
  }

  // Save data to database
  void saveSong() async {
    moveToLastScreen();

    song.updated = DateFormat.yMMMd().format(DateTime.now());
    //int result = 0;
    if (song.songid != null) {
      await db.updateSong(song);
    } else {
      song.bookid = 50;
      await db.insertSong(song);
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  /// Go back to the screen before the current one
  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}
