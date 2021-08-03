import 'dart:math';

import 'package:vsongbook/data/models/song_model.dart';

import '../data/models/list_item.dart';
import '../data/models/book_model.dart';
import '../data/callbacks/Book.dart';
import '../data/app_database.dart';
import '../utils/preferences.dart';

Future<void> saveBooks(List<ListItem<Book>> books) async {
  AppDatabase db = AppDatabase();

  for (int i = 0; i < books.length; i++) {
    Book item = books[i].data;
    int songs = int.parse(item.qcount);
    int cartid = int.parse(item.categoryid);
    BookModel book = BookModel(cartid, 1, item.title, item.tags, songs, i + 1,
        item.content, item.backpath);
    await db.insertBook(book);
  }
  String selectedbooks = "";
  for (int i = 0; i < books.length; i++)
    selectedbooks = selectedbooks + books[i].data.categoryid + ",";

  try {
    selectedbooks = selectedbooks.substring(0, selectedbooks.length - 1);
  } catch (Exception) {}

  Preferences.setBooksLoaded(true);
  Preferences.setSelectedBooks(selectedbooks);
}

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}

String refineTitle(String songTitle) {
  return songTitle.replaceAll("''L", "'l").replaceAll("''", "'");
}

String refineContent(String songContent) {
  return songContent.replaceAll("''", "'").replaceAll("\\n", " ");
}

String songItemTitle(int number, String title) {
  return number.toString() + ". " + refineTitle(title);
}

String songCopyString(String title, String content) {
  return title + "\n\n" + content;
}

String bookCountString(String title, int count) {
  return title + ' (' + count.toString() + ')';
}

String lyricsString(String lyrics) {
  return lyrics.replaceAll("\\n", "\n").replaceAll("''", "'");
}

String songViewerTitle(int number, String title, String alias) {
  String songtitle = number.toString() + ". " + refineTitle(title);

  if (alias.length > 2 && title != alias)
    songtitle = songtitle + " (" + refineTitle(alias) + ")";

  return songtitle;
}

String songShareString(String title, String content) {
  return title +
      "\n\n" +
      content +
      "\n\nvia #vSongBook https://Appsmata.com/vSongBook";
}

String verseOfString(String number, int count) {
  return 'VERSE ' + number + ' of ' + count.toString();
}

double getFontSize(int characters, double height, double width) {
  return sqrt((height * width) / characters);
}
