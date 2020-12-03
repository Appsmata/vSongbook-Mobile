class SongModel {
  int _songid;
  int _postid;
  int _bookid;
  int _categoryid;
  String _basetype;
  int _number;
  String _title;
  String _alias;
  String _content;
  String _tags;
  String _key;
  String _author;
  String _notes;
  String _created;
  String _updated;
  String _metawhat;
  String _metawhen;
  String _metawhere;
  String _metawho;
  int _netthumbs;
  int _views;
  int _isfav;
  int _acount;
  int _userid;

  SongModel(
      this._postid,
      this._bookid,
      this._basetype,
      this._number,
      this._title,
      this._alias,
      this._content,
      this._key,
      this._author,
      this._userid,
      this._created);

  int get songid => _songid;
  int get postid => _postid;
  int get bookid => _bookid;
  int get categoryid => _categoryid;
  String get basetype => _basetype;
  int get number => _number;
  String get title => _title;
  String get alias => _alias;
  String get content => _content;
  String get tags => _tags;
  String get key => _key;
  String get author => _author;
  String get notes => _notes;
  String get created => _created;
  String get updated => _updated;
  String get metawhat => _metawhat;
  String get metawhen => _metawhen;
  String get metawhere => _metawhere;
  String get metawho => _metawho;
  int get netthumbs => _netthumbs;
  int get views => _views;
  int get isfav => _isfav;
  int get acount => _acount;
  int get userid => _userid;

  set bookid(int newBookid) {
    this._bookid = newBookid;
  }

  set postid(int newPostid) {
    this._postid = newPostid;
  }

  set categoryid(int newCategoryid) {
    this._categoryid = newCategoryid;
  }

  set basetype(String newBasetype) {
    this._basetype = newBasetype;
  }

  set number(int newNumber) {
    this._number = newNumber;
  }

  set title(String newTitle) {
    if (newTitle.length <= 10) {
      this._title = newTitle;
    }
  }

  set alias(String newAlias) {
    if (newAlias.length <= 10) {
      this._alias = newAlias;
    }
  }

  set content(String newContent) {
    if (newContent.length <= 10) {
      this._content = newContent;
    }
  }

  set tags(String newTags) {
    this._tags = newTags;
  }

  set key(String newKey) {
    this._key = newKey;
  }

  set author(String newAuthor) {
    this._author = newAuthor;
  }

  set notes(String newNotes) {
    if (newNotes.length <= 10) {
      this._notes = newNotes;
    }
  }

  set userid(int newUserid) {
    this._userid = newUserid;
  }

  set views(int newViews) {
    this._views = newViews;
  }

  set isfav(int newIsfav) {
    this._isfav = newIsfav;
  }

  set netthumbs(int newNetthumbs) {
    this._netthumbs = newNetthumbs;
  }

  set acount(int newAcount) {
    this._acount = newAcount;
  }

  set created(String newDate) {
    this._created = newDate;
  }

  set updated(String newDate) {
    this._updated = newDate;
  }

  set metawhat(String newMetawhat) {
    this._metawhat = newMetawhat;
  }

  set metawhere(String newMetawhere) {
    this._metawhere = newMetawhere;
  }

  set metawhen(String newMetawhen) {
    this._metawhen = newMetawhen;
  }

  set metawho(String newMetawho) {
    this._metawho = newMetawho;
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (songid != null) {
      map['songid'] = _postid;
    }
    map['postid'] = _postid;
    map['bookid'] = _bookid;
    map['categoryid'] = _categoryid;
    map['basetype'] = _basetype;
    map['number'] = _number;
    map['alias'] = _alias;
    map['title'] = _title;
    map['tags'] = _tags;
    map['content'] = _content;
    map['key'] = _key;
    map['author'] = _author;
    map['notes'] = _notes;
    map['created'] = _created;
    map['updated'] = _updated;
    map['metawhat'] = _metawhat;
    map['metawhen'] = _metawhen;
    map['metawhere'] = _metawhere;
    map['metawho'] = _metawho;
    map['netthumbs'] = _netthumbs;
    map['views'] = _views;
    map['isfav'] = _isfav;
    map['acount'] = _acount;
    map['userid'] = _userid;

    return map;
  }

  // Extract a Note object from a Map object
  SongModel.fromMapObject(Map<String, dynamic> map) {
    this._songid = map['songid'];
    this._bookid = map['bookid'];
    this._categoryid = map['categoryid'];
    this._basetype = map['basetype'];
    this._number = map['number'];
    this._alias = map['alias'];
    this._title = map['title'];
    this._tags = map['tags'];
    this._content = map['content'];
    this._key = map['key'];
    this._author = map['author'];
    this._notes = map['notes'];
    this._created = map['created'];
    this._updated = map['updated'];
    this._metawhat = map['metawhat'];
    this._metawhen = map['metawhen'];
    this._metawhere = map['metawhere'];
    this._metawho = map['metawho'];
    this._netthumbs = map['netthumbs'];
    this._views = map['views'];
    this._isfav = map['isfav'];
    this._acount = map['acount'];
    this._userid = map['userid'];
  }
}
