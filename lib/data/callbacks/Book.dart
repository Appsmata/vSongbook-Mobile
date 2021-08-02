class Book {
  String categoryid, title, tags, qcount, content, backpath;

  Book(
      {this.categoryid,
      this.title,
      this.tags,
      this.qcount,
      this.content,
      this.backpath});

  Book.fromJson(Map<String, dynamic> json) {
    categoryid = json['categoryid'];
    title = json['title'];
    tags = json['tags'];
    qcount = json['qcount'];
    content = json['content'];
    backpath = json['backpath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['categoryid'] = this.categoryid;
    data['title'] = this.title;
    data['tags'] = this.tags;
    data['qcount'] = this.qcount;
    data['content'] = this.content;
    data['backpath'] = this.backpath;
    return data;
  }

  static List<Book> fromData(List<Map<String, dynamic>> data) {
    return data.map((cat) => Book.fromJson(cat)).toList();
  }
}
