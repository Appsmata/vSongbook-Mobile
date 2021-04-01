
class Tables {
  static const String books = 'as_books';
  static const String songs = 'as_songs';
  static const String sermons = 'as_sermons';
  static const String tithing = 'as_tithing';
}

class Columns {
  static const int ownsongs = 50;
  static const String bookid = 'bookid';
  static const String categoryid = 'categoryid';
  static const String enabled = 'enabled';
  static const String title = 'title';
  static const String tags = 'tags';
  static const String qcount = 'qcount';
  static const String position = 'position';
  static const String content = 'content';
  static const String backpath = 'backpath';
  static const String created = 'created';
  static const String updated = 'updated';

  static const String songid = 'songid';
  static const String postid = 'postid';
  static const String number = 'number';
  static const String basetype = 'basetype';
  static const String alias = 'alias';
  static const String views = 'views';
  static const String key = 'key';
  static const String isfav = 'isfav';
  static const String author = 'author';
  static const String notes = 'notes';
  static const String metawhat = 'metawhat';
  static const String metawhen = 'metawhen';
  static const String metawhere = 'metawhere';
  static const String metawho = 'metawho';
  static const String netthumbs = 'netthumbs';
  static const String acount = 'acount';
  static const String userid = 'userid';

  static const String sermonid = 'sermonid';
  static const String subtitle = 'subtitle';
  static const String preacher = 'preacher';
  static const String place = 'place';
  static const String extra = 'extra';
  static const String state = 'state';

  static const String titheid = 'titheid';
  static const String source = 'source';
  static const String mode = 'mode';
  static const String amount = 'amount';
}

class Queries {
  static const String createBooksTable = 'CREATE TABLE ' +
      Tables.books + '(' +
      Columns.bookid + ' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, ' +
      Columns.categoryid + ' INTEGER NOT NULL DEFAULT 0, ' +
      Columns.enabled + ' INTEGER NOT NULL DEFAULT 0, ' +
      Columns.title + ' VARCHAR(100) UNIQUE, ' +
      Columns.tags + ' VARCHAR(250) UNIQUE, ' +
      Columns.qcount + ' INTEGER NOT NULL DEFAULT 0, ' +
      Columns.position + ' INTEGER NOT NULL DEFAULT 0, ' +
      Columns.content + ' VARCHAR(1000), ' +
      Columns.backpath + ' VARCHAR(250) UNIQUE, ' +
      Columns.created + ' VARCHAR(20), ' +
      Columns.updated + ' VARCHAR(20)' +
      ");";
  static const String createSongsTable = 'CREATE TABLE ' +
      Tables.songs + '(' +
      Columns.songid + ' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, ' +
      Columns.postid + ' INTEGER UNIQUE, ' +
      Columns.bookid + ' INTEGER, ' +
      Columns.categoryid + ' INTEGER, ' +
      Columns.basetype + ' VARCHAR(20), ' +
      Columns.number + ' INTEGER NOT NULL DEFAULT 0, ' +
      Columns.alias + ' VARCHAR(250), ' +
      Columns.title + ' VARCHAR(100), ' +
      Columns.tags + ' VARCHAR(100), ' +
      Columns.content + ' VARCHAR(50000), ' +
      Columns.key + ' VARCHAR(10), ' +
      Columns.author + ' VARCHAR(100), ' +
      Columns.notes + ' VARCHAR(250), ' +
      Columns.created + ' VARCHAR(20), ' +
      Columns.updated + ' VARCHAR(20), ' +
      Columns.metawhat + ' VARCHAR(20), ' +
      Columns.metawhen + ' VARCHAR(20), ' +
      Columns.metawhere + ' VARCHAR(20), ' +
      Columns.metawho + ' VARCHAR(20), ' +
      Columns.netthumbs + ' INTEGER, ' +
      Columns.views + ' INTEGER NOT NULL DEFAULT 0, ' +
      Columns.isfav + ' INTEGER NOT NULL DEFAULT 0, ' +
      Columns.acount + ' INTEGER, ' +
      Columns.userid + ' INTEGER' +
      ");";

  static const String createSermonsTable = 'CREATE TABLE ' +
      Tables.sermons + '(' +
      Columns.sermonid + ' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, ' +
      Columns.categoryid + ' INTEGER NOT NULL DEFAULT 0, ' +
      Columns.title + ' VARCHAR(100), ' +
      Columns.subtitle + ' VARCHAR(100), ' +
      Columns.preacher + ' VARCHAR(100), ' +
      Columns.place + ' VARCHAR(100), ' +
      Columns.extra + ' VARCHAR(200), ' +
      Columns.tags + ' VARCHAR(100), ' +
      Columns.content + ' VARCHAR(50000), ' +
      Columns.created + ' VARCHAR(20), ' +
      Columns.updated + ' VARCHAR(20), ' +
      Columns.state + ' INTEGER NOT NULL DEFAULT 0, ' +
      Columns.isfav + ' INTEGER NOT NULL DEFAULT 0' +
      ");";

  static const String createTithingTable = 'CREATE TABLE ' +
      Tables.tithing + '(' +
      Columns.titheid + ' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, ' +
      Columns.source + ' VARCHAR(50), ' +
      Columns.mode + ' VARCHAR(20), ' +
      Columns.amount + ' INTEGER NOT NULL DEFAULT 0, ' +
      Columns.extra + ' VARCHAR(100), ' +
      Columns.created + ' INTEGER NOT NULL DEFAULT 0' +
      ");";

  static String searchQuery(String searchStr) {
    return ' WHERE ' + Tables.songs + '.' + Columns.title + " LIKE '%$searchStr%' $bookQuery OR " + 
      Tables.songs + '.' + Columns.alias + " LIKE '%$searchStr%' $bookQuery OR " + 
      Tables.songs + '.' + Columns.content + " LIKE '%$searchStr%' $bookQuery" + songsOrderby;
  }
  
  static const String selectSongsColumns = 
      'SELECT ' + 
        Columns.songid + ', ' +  Columns.postid + ', ' + Tables.songs + '.' + Columns.bookid + ', ' + 
        Tables.songs + '.' + Columns.categoryid +  ', ' + Columns.number + ', ' + Columns.alias + ', ' + 
        Tables.songs + '.' + Columns.title + ', ' + Tables.songs + '.' + Columns.content + ', ' + 
        Columns.key + ', ' + Tables.songs + '.' + Columns.created + ', ' + 
        Tables.songs + '.' + Columns.isfav + ', ' +  Tables.books + "." + Columns.title + ' AS songbook' +
      ' FROM ' + Tables.songs + 
      ' LEFT JOIN ' + Tables.books + ' ON ' + Tables.books + '.' + Columns.categoryid + '=' + Tables.songs + '.' + Columns.bookid;

  static const String songsOrderby = ' ORDER BY ' +  Columns.songid + ' ASC';

  static String whereSongsBookid(String book)
  {
    return ' WHERE ' + Tables.songs + '.' + Columns.bookid + '=' + book + songsOrderby;
  }

  static String whereSongsNumber(int songno)
  {
    return ' WHERE ' + Tables.songs + '.' + Columns.bookid + '=' + songno.toString() + songsOrderby;
  }

  static String bookQuery = 'AND ' + Tables.songs + '.' + Columns.bookid + '!=' + Columns.ownsongs.toString();
  
  static String whereSongMatch(String searchStr)
  {
    return ' WHERE ' + Tables.songs + '.' + Columns.title + " LIKE '%$searchStr%' $bookQuery OR " + 
     Tables.songs + '.' +  Columns.alias + " LIKE '%$searchStr%' $bookQuery OR " + 
      Tables.songs + '.' + Columns.content + " LIKE '%$searchStr%' $bookQuery" + songsOrderby;
  }

}
