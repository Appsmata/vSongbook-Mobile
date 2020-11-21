import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:vsongbook/utils/colors.dart';
import 'package:vsongbook/utils/constants.dart';
import 'package:vsongbook/models/song_model.dart';
import 'package:vsongbook/helpers/sqlite_helper.dart';
import 'package:vsongbook/screens/ee_song_view.dart';

class AsSongItem extends StatelessWidget {

  final SongModel song;
  SqliteHelper db = SqliteHelper();
  List<SongModel> songList;

  AsSongItem(this.song);

  @override
  Widget build(BuildContext context) {
    
    int category = song.bookid;
    String songBook = "Songs of Worship";
    String songTitle = song.number.toString() + ". " + song.title;
    String strContent = '<h2>' + songTitle + '</h2>';

    var verses = song.content.split("\\n\\n");
    var songConts = song.content.split("\\n");
    strContent = strContent + songConts[0] + ' ' + songConts[1] + " ... <br><small><i>";

    /*try {
      BookModel curbook = books.firstWhere((i) => i.categoryid == category);
      strContent = strContent + "\n" + curbook.title + "; ";
      songBook = curbook.title;
    } catch (Exception) {
      strContent = strContent + "\n";
    }*/

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
          //navigateToSong(songs[index], songBook);
        },
      ),
    );
  }
}