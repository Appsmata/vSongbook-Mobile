
class BookModel {
  int _bookid;
  int _categoryid;
  int _enabled;
  String _title;
  String _tags;
  int _qcount;
  int _position;
  String _content;
  String _backpath;
  String _created;
  String _updated;

	BookModel(this._categoryid, this._enabled, this._title, this._tags, this._qcount, this._position, this._content, this._backpath);
  
	int get bookid => _bookid;
	int get categoryid => _categoryid;
	int get enabled => _enabled;
	String get title => _title;
	String get tags => _tags;
	int get qcount => _qcount;
	int get position => _position;
	String get content => _content;
	String get backpath => _backpath;
	String get created => _created;
	String get updated => _updated;

	set enabled(int isEnabled) {
		this._enabled = isEnabled;
	}

	set title(String newTitle) {
		if (newTitle.length <= 10) {
			this._title = newTitle;
		}
	}

	set tags(String newTags) {
		this._tags = newTags;
	}

	set qcount(int newQcount) {
		this._qcount = newQcount;
	}

	set position(int newPosition) {
		this._position = newPosition;
	}

	set content(String newDescription) {
		if (newDescription.length <= 10) {
			this._content = newDescription;
		}
	}

	set backpath(String newCode) {
		if (newCode.length <= 5) {
			this._backpath = newCode;
		}
	}

	set created(String newDate) {
		this._created = newDate;
	}

	set updated(String newDate) {
		this._updated = newDate;
	}

	// Convert a Note object into a Map object
	Map<String, dynamic> toMap() {

		var map = Map<String, dynamic>();
		if (bookid != null) {
			map['bookid'] = _categoryid;
		}
		map['categoryid'] = _categoryid;
		map['enabled'] = _enabled;
		map['title'] = _title;
		map['tags'] = _tags;
		map['qcount'] = _qcount;
		map['position'] = _position;
		map['content'] = _content;
		map['backpath'] = _backpath;
		map['created'] = _created;
		map['updated'] = _updated;
    
		return map;
	}

	// Extract a Note object from a Map object
	BookModel.fromMapObject(Map<String, dynamic> map) {
		this._bookid = map['bookid'];
		this._categoryid = map['categoryid'];
		this._enabled = map['enabled'];
		this._title = map['title'];
		this._tags = map['tags'];
		this._qcount = map['qcount'];
		this._position = map['position'];
		this._content = map['content'];
		this._backpath = map['backpath'];
		this._created = map['created'];
		this._updated = map['updated'];
	}
}
