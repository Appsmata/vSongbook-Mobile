import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/app_helper.dart';
import '../../../services/app_settings.dart';
import '../../../utils/colors.dart';
import '../../../utils/app_utils.dart';
import '../../../data/models/book_model.dart';
import '../../../data/models/song_model.dart';
import 'song_view.dart';

class SongItem extends StatelessWidget {
  final String heroTag;
  final SongModel song;
  final List<BookModel> books;
  final BuildContext context;

  SongItem(this.heroTag, this.song, this.books, this.context);
  String songBook;

  @override
  Widget build(BuildContext context) {
    String hasChorus, verseCount = '';

    var verses = song.content.split("\\n\\n");

    if (song.content.contains("CHORUS")) {
      hasChorus = AppStrings.hasChorus;
      verseCount = verses.length.toString() + ' Vs';
    } else {
      hasChorus = AppStrings.noChorus;
      verseCount = verses.length.toString() + ' Vs';
    }

    try {
      BookModel curbook = books.firstWhere((i) => i.categoryid == song.bookid);
      songBook = curbook.title;
    } catch (Exception) {
      songBook = "";
    }

    return GestureDetector(
      child: Hero(
        tag: this.heroTag,
        child: Container(
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            color: Provider.of<AppSettings>(context).isDarkMode
                ? ColorUtils.black
                : ColorUtils.white,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                songItemTitle(song.number, song.title),
                maxLines: 1,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text(
                refineContent(verses[0]),
                maxLines: 2,
                style: TextStyle(fontSize: 16),
              ),
              Container(
                height: 35,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    tagView(songBook),
                    tagView(hasChorus),
                    tagView(verseCount),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        navigateToSong();
      },
    );
  }

  Widget tagView(String tagText) {
    try {
      if (tagText.isNotEmpty) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          margin: EdgeInsets.only(top: 5, left: 5),
          decoration: BoxDecoration(
            color: Provider.of<AppSettings>(context).isDarkMode
                ? ColorUtils.black
                : ColorUtils.primaryColor,
            border: Border.all(
                color: Provider.of<AppSettings>(context).isDarkMode
                    ? ColorUtils.white
                    : ColorUtils.secondaryColor),
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: [BoxShadow(blurRadius: 1)],
          ),
          child: Text(
            tagText,
            style: TextStyle(
              color: ColorUtils.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        );
      } else
        return Container();
    } catch (Exception) {
      return Container();
    }
  }

  void navigateToSong() async {
    bool haschorus = false;
    if (song.content.contains("CHORUS")) haschorus = true;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return SongView(this.song, haschorus, songBook);
        },
      ),
    );
  }
}
