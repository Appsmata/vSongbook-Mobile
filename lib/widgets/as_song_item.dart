import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vsongbook/helpers/app_base.dart';
import 'package:vsongbook/helpers/app_settings.dart';
import 'package:vsongbook/utils/constants.dart';
import 'package:vsongbook/models/song_model.dart';
import 'package:vsongbook/screens/ee_song_view.dart';

class AsSongItem extends StatelessWidget {

  final String heroTag;
  final SongModel song;
  final BuildContext context;

  AsSongItem(this.heroTag, this.song, this.context);

  @override
  Widget build(BuildContext context) {
    String songTitle = song.number.toString() + ". " + refineTitle(song.title);
    String hasChorus, verseCount = '';

    var verses = song.content.split("\\n\\n");

    if (song.content.contains("CHORUS")) {
      hasChorus = LangStrings.HasChorus;
      verseCount = verses.length.toString() + (verses.length == 1 ? ' V' : ' Vs');
    } else {
      hasChorus = LangStrings.NoChorus;
      verseCount = verses.length.toString() + (verses.length == 1 ? ' V' : ' Vs');
    }

    return GestureDetector(
      child: Hero(
        tag: this.heroTag,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(songTitle, maxLines: 1, style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                  Text(refineContent(verses[0]), maxLines: 2, style: new TextStyle(fontSize: 18)),
                  Container(
                    height: 35,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        tagView(song.songbook),
                        tagView(hasChorus),
                        tagView(verseCount),
                      ]
                    ),
                  )
                ]
              )
            ),
            Divider(),
          ]
        ),
      ),
      onTap: () {
        navigateToSong();
      },
    );    
  }
  
  Widget tagView(String tagText)
  {
    try {
      if (tagText.isNotEmpty)
      {
        return Container(
          padding: const EdgeInsets.all(5),
          margin: EdgeInsets.only(top: 5, left: 5),
          decoration: new BoxDecoration( 
            color: Provider.of<AppSettings>(context).isDarkMode ? Colors.black : Colors.deepOrange,
            border: Border.all(color: Provider.of<AppSettings>(context).isDarkMode ? Colors.white : Colors.orange),
            borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomLeft: Radius.circular(5)),
          ),
          child: Text( tagText,style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
          ),
        );
    }
    else return Container();      
    } catch (Exception) {
      return Container(); 
    }    
  }

  void navigateToSong() async {
    bool haschorus = false;
    if (song.content.contains("CHORUS")) haschorus = true;
    
    print(this.heroTag);
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EeSongView(this.song, haschorus, this.song.songbook);
    }));
  }
}