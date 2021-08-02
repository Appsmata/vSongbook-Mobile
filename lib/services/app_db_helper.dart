import '../data/models/list_item.dart';
import '../data/models/book_model.dart';
import '../data/callbacks/Book.dart';
import '../data/app_database.dart';
import '../utils/preferences.dart';

/// App Database helper class
class AppDbHelper {
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
}
