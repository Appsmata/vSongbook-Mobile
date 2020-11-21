import 'package:flutter/material.dart';

class SongListItem extends StatelessWidget {
  const SongListItem({
    this.favourite,
    this.title,
    this.content,
    this.details,
  });

  final Widget favourite;
  final String title;
  final String content;
  final String details;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: favourite,
          ),
          Expanded(
            flex: 3,
            child: SongDescription(
              title: title,
              content: content,
              details: details,
            ),
          ),
          const Icon(
            Icons.more_vert,
            size: 16.0,
          ),
        ],
      ),
    );
  }
}

class SongDescription extends StatelessWidget {
  const SongDescription({
    Key key,
    this.title,
    this.content,
    this.details,
  }) : super(key: key);

  final String title;
  final String content;
  final String details;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14.0,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
          Text(
            content,
            style: const TextStyle(fontSize: 10.0),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
          Text(
            '$details views',
            style: const TextStyle(fontSize: 10.0),
          ),
        ],
      ),
    );
  }
}
