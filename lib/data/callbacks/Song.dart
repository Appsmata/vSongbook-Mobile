class Song {
  String postid;
  String number;
  String title;
  String alias;
  String content;
  String tags;
  String created;
  String categoryid;
  String who;
  String netthumbs;
  String acount;
  String userid;

  Song(
      {this.postid,
      this.number,
      this.title,
      this.alias,
      this.content,
      this.tags,
      this.created,
      this.categoryid,
      this.who,
      this.netthumbs,
      this.acount,
      this.userid});

  Song.fromJson(Map<String, dynamic> json) {
    postid = json['postid'];
    number = json['number'];
    title = json['title'];
    alias = json['alias'];
    content = json['content'];
    tags = json['tags'];
    created = json['created'];
    categoryid = json['categoryid'];
    who = json['who'];
    netthumbs = json['netthumbs'];
    acount = json['acount'];
    userid = json['userid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['postid'] = this.postid;
    data['number'] = this.number;
    data['title'] = this.title;
    data['alias'] = this.alias;
    data['content'] = this.content;
    data['tags'] = this.tags;
    data['created'] = this.created;
    data['categoryid'] = this.categoryid;
    data['who'] = this.who;
    data['netthumbs'] = this.netthumbs;
    data['acount'] = this.acount;
    data['userid'] = this.userid;
    return data;
  }
  
  static List<Song> fromData(List<Map<String, dynamic>> data) {
    return data.map((cat) => Song.fromJson(cat)).toList();
  }
}