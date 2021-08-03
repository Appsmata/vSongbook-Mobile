import 'dart:async';
import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../services/app_helper.dart';
import '../utils/db_utils.dart';
import 'models/book_model.dart';
import 'models/song_model.dart';

class AppDatabase {
  static AppDatabase sqliteHelper; // Singleton DatabaseHelper
  static Database appDb; // Singleton Database

  AppDatabase._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory AppDatabase() {
    if (sqliteHelper == null) {
      sqliteHelper = AppDatabase
          ._createInstance(); // This is executed only once, singleton object
    }
    return sqliteHelper;
  }

  Future<Database> get database async {
    if (appDb == null) {
      appDb = await initializeDatabase();
    }
    return appDb;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory docsDirectory = await getApplicationDocumentsDirectory();
    String path = join(docsDirectory.path, 'vSongBookApp.db');

    // Open/create the database at a given path
    var vsbDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return vsbDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(Queries.createBooksTable);
    await db.execute(Queries.createSermonsTable);
    await db.execute(Queries.createSongsTable);
    await db.execute(Queries.createTithingTable);
  }

  Future<List<Map<String, dynamic>>> getBookMapList() async {
    Database db = await this.database;

    var result =
        await db.query(Tables.books, orderBy: Columns.categoryid + " ASC");
    return result;
  }

  void manageSongbooks() async {
    Database db = await this.database;
    await db.execute("DROP TABLE " + Tables.books + ";");
    await db.execute("DROP TABLE " + Tables.songs + ";");
    await db.execute(Queries.createBooksTable);
    await db.execute(Queries.createSongsTable);
  }

  Future<int> insertBook(BookModel book) async {
    Database db = await this.database;
    book.created = book.updated = "";
    var result = await db.insert(Tables.books, book.toMap());
    return result;
  }

  Future<int> updateBook(BookModel book) async {
    var db = await this.database;
    var result = await db.update(Tables.books, book.toMap(),
        where: Columns.bookid + " = ?", whereArgs: [book.bookid]);
    return result;
  }

  Future<int> updateBookCompleted(BookModel book) async {
    var db = await this.database;
    var result = await db.update(Tables.books, book.toMap(),
        where: Columns.bookid + " = ?", whereArgs: [book.bookid]);
    return result;
  }

  Future<int> deleteBook(int id) async {
    var db = await this.database;
    int result = await db.rawDelete(
        "DELETE FROM " + Tables.books + " WHERE " + Columns.bookid + " = $id");
    result = await db.rawDelete(
        "DELETE FROM " + Tables.songs + " WHERE " + Columns.bookid + " = $id");
    return result;
  }

  Future<int> getBookCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery("SELECT COUNT (*) from " + Tables.books);
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<BookModel>> getBookList() async {
    var bookMapList = await getBookMapList();
    int count = bookMapList.length;

    List<BookModel> bookList = [];
    for (int i = 0; i < count; i++) {
      bookList.add(BookModel.fromMapObject(bookMapList[i]));
    }

    return bookList;
  }

  //QUERIES FOR SONGS
  Future<int> insertSong(SongModel song) async {
    Database db = await this.database;
    song.updated = song.basetype = song.notes =
        song.metawhat = song.metawhen = song.metawhere = song.metawho = "";
    song.views = song.isfav = song.netthumbs = song.acount = 0;

    var result = await db.insert(Tables.songs, song.toMap());
    return result;
  }

  Future<int> updateSong(SongModel song) async {
    var db = await this.database;
    var result = await db.update(Tables.songs, song.toMap(),
        where: Columns.songid + " = ?", whereArgs: [song.songid]);
    return result;
  }

  Future<int> favouriteSong(SongModel song, bool isFavorited) async {
    var db = await this.database;
    if (isFavorited) song.isfav = 1;
    else song.isfav = 0;
    var result = await db.rawUpdate("UPDATE " + Tables.songs + " SET " + Columns.isfav + "=" + song.isfav.toString() + 
      " WHERE " + Columns.songid + "=" + song.songid.toString());
    return result;
  }

  Future<int> deleteSong(int songID) async {
    var db = await this.database;
    int result = await db.rawDelete("DELETE FROM " + Tables.songs + " WHERE " + Columns.songid + "=" + songID.toString());
    return result;
  }

  Future<int> getSongCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery("SELECT COUNT (*) from " + Tables.songs);
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  //SONGS LISTS
  Future<List<Map<String, dynamic>>> getSongMapList(int book) async {
    Database db = await this.database;

    if (book != 0) return db.rawQuery(Queries.selectSongsColumns + Queries.whereSongsBookid(book.toString()));
    else return db.rawQuery(Queries.selectSongsColumns + Queries.songsOrderby);
  }

  Future<List<SongModel>> getSongList(int book) async {
    var songMapList = await getSongMapList(book);
    List<SongModel> songList = [];
    for (int i = 0; i < songMapList.length; i++) {
      songList.add(SongModel.fromMapObject(songMapList[i]));
    }
    return songList;
  }

  //SONG SEARCH
  Future<List<Map<String, dynamic>>> getSongSearchMapList(String searchThis) async {
    Database db = await this.database;

    var result;
    if (isNumeric(searchThis)) {
      try {
        int searchno = int.parse(searchThis);

        if (searchno > 0) result = db.rawQuery(Queries.selectSongsColumns + Queries.whereSongsNumber(searchno));
        else result = db.rawQuery(Queries.selectSongsColumns + Queries.whereSongMatch(searchThis));
      } catch (Exception) {
        result = db.rawQuery(Queries.selectSongsColumns + Queries.whereSongMatch(searchThis));
      }
    } else
      result = db.query(Tables.songs, where: Queries.searchQuery(searchThis));
    return result;
  }

  Future<List<SongModel>> getSongSearch(String searchThis) async {
    var songMapList = await getSongSearchMapList(searchThis);

    List<SongModel> songList = [];
    for (int i = 0; i < songMapList.length; i++) {
      songList.add(SongModel.fromMapObject(songMapList[i]));
    }
    return songList;
  }

  //FAVOURITES LISTS
  Future<List<Map<String, dynamic>>> getFavoritesList() async {
    Database db = await this.database;
    var result = db.query(Tables.songs, where: Columns.isfav + "=1");
    return result;
  }

  Future<List<SongModel>> getFavorites() async {
    var songMapList = await getFavoritesList();

    List<SongModel> songList = [];
    for (int i = 0; i < songMapList.length; i++) {
      songList.add(SongModel.fromMapObject(songMapList[i]));
    }

    return songList;
  }

  //FAVORITE SEARCH
  Future<List<Map<String, dynamic>>> getFavSearchMapList(
      String searchThis) async {
    Database db = await this.database;
    String bookQuery = "AND " + Columns.isfav + "=1";
    String sqlQuery = Columns.title + " LIKE '$searchThis%' $bookQuery OR " +
        Columns.alias + " LIKE '$searchThis%' $bookQuery OR " +
        Columns.content + " LIKE '$searchThis%' $bookQuery";

    var result;
    if (isNumeric(searchThis)) {
      try {
        int searchno = int.parse(searchThis);
        if (searchno > 0)
          result = db.query(Tables.songs,
              where: Columns.number + "=" + searchno.toString());
        else
          result = db.query(Tables.songs, where: sqlQuery);
      } catch (Exception) {
        result = db.query(Tables.songs, where: sqlQuery);
      }
    } else
      result = db.query(Tables.songs, where: sqlQuery);
    return result;
  }

  Future<List<SongModel>> getFavSearch(String searchThis) async {
    var songMapList = await getFavSearchMapList(searchThis);

    List<SongModel> songList = [];
    // For loop to create a "song List" from a "Map List"
    for (int i = 0; i < songMapList.length; i++) {
      songList.add(SongModel.fromMapObject(songMapList[i]));
    }
    return songList;
  }

  //DRAFT SEARCH
  Future<List<Map<String, dynamic>>> getDraftSearchMapList(
      String searchThis) async {
    Database db = await this.database;
    String bookQuery = "AND " + Columns.bookid + "=" + Columns.ownsongs.toString();
    String sqlQuery = Columns.title + " LIKE '$searchThis%' $bookQuery OR " +
        Columns.alias + " LIKE '$searchThis%' $bookQuery OR " +
        Columns.content + " LIKE '$searchThis%' $bookQuery";

    var result = db.query(Tables.songs, where: sqlQuery);
    return result;
  }

  Future<List<SongModel>> getDraftSearch(String searchThis) async {
    var songMapList = await getDraftSearchMapList(searchThis);

    List<SongModel> songList = [];
    // For loop to create a "song List" from a "Map List"
    for (int i = 0; i < songMapList.length; i++) {
      songList.add(SongModel.fromMapObject(songMapList[i]));
    }
    return songList;
  }
}
