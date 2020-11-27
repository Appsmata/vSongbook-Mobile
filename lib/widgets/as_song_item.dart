import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:vsongbook/utils/constants.dart';
import 'package:vsongbook/models/song_model.dart';
//import 'package:vsongbook/screens/ee_song_view.dart';

class AsSongItem extends StatelessWidget {

  final SongModel song;

  AsSongItem(this.song);

  @override
  Widget build(BuildContext context) {
    
    String songBook = "";
    String songTitle = song.number.toString() + ". " + song.title;
    String strContent = '<h2>' + songTitle + '</h2>';

    var verses = song.content.split("\\n\\n");
    var songConts = song.content.split("\\n");
    strContent = strContent + songConts[0] + ' ' + songConts[1] + " ... <br><small><i>";

    try {
      if (song.songbook.isNotEmpty)
      {
        songBook = song.songbook;
        strContent = strContent + "\n" + songBook + "; ";
      }
    }
    catch (Exception) {
      
    }     
    
     
    if (song.content.contains("CHORUS")) {
      strContent = strContent + LangStrings.HasChorus;
      strContent = strContent + verses.length.toString() + LangStrings.Verses;
    } else {
      strContent = strContent + LangStrings.NoChorus;
      strContent = strContent + verses.length.toString() + LangStrings.Verses;
    }

    return Card(
      elevation: 2,
      child: GestureDetector(
        child: Html(
          data: strContent + '</i></small>',
          style: {
            "html": Style(
              fontSize: FontSize(20.0),
            ),
            "ul": Style(
              fontSize: FontSize(18.0),
            ),
          },
        ),
        onTap: () {
          navigateToSong(song, songBook);
        },
      ),
    );
  }
  
  void navigateToSong(SongModel song, String songbook) async {
    bool haschorus = false;
    if (song.content.contains("CHORUS")) haschorus = true;
    /*await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EeSongView(song, haschorus, songbook);
    }));*/
  }
}