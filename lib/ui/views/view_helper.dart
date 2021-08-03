import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';

import '../../services/app_helper.dart';
import '../../data/app_database.dart';
import '../../data/models/song_model.dart';
import '../../utils/app_utils.dart';
import '../../ui/pages/songs/song_edit.dart';

Widget menuPopup(BuildContext context) => PopupMenuButton<int>(
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Text(AppStrings.quickSettings),
        ),
        PopupMenuItem(
          value: 2,
          child: Text(AppStrings.manageApp),
        ),
        PopupMenuItem(
          value: 3,
          child: Text(AppStrings.supportUs),
        ),
        PopupMenuItem(
          value: 4,
          child: Text(AppStrings.helpFeedback),
        ),
        PopupMenuItem(
          value: 5,
          child: Text(AppStrings.aboutTheApp + AppStrings.appName),
        ),
      ],
      onCanceled: () {},
      onSelected: (value) {
        //selectedMenu(value, context);
      },
      icon: Icon(
        Theme.of(context).platform == TargetPlatform.iOS
            ? Icons.more_horiz
            : Icons.more_vert,
      ),
    );

List<Widget> floatingButtons(
    BuildContext context, SongModel song, String songContent) {
  return <Widget>[
    FloatingActionButton(
      heroTag: null,
      child: Icon(Icons.content_copy),
      tooltip: AppStrings.copySong,
      onPressed: () async {
        Clipboard.setData(
          ClipboardData(
            text: songCopyString(song.title, songContent),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppStrings.songCopied),
          ),
        );
      },
    ),
    FloatingActionButton(
      heroTag: null,
      child: Icon(Icons.share),
      onPressed: () async {
        Share.share(
          songShareString(song.title, songContent),
          subject: "Share the song: " + song.title,
        );
      },
    ),
    FloatingActionButton(
      heroTag: null,
      child: Icon(Icons.edit),
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return SongEdit(song, "Editting: " + song.title);
            },
          ),
        );
      },
    ),
  ];
}

  Widget copyVerse(int index, String lyrics, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: FloatingActionButton(
          heroTag: "CopyVerse_" + index.toString(),
          child: Icon(Icons.content_copy),
          tooltip: AppStrings.copyVerse,
          onPressed: () async {
            Clipboard.setData(ClipboardData(text: lyrics));
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(AppStrings.verseCopied)));
          }),
    );
  }

  Widget shareVerse(SongModel song, int index, String lyrics) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: FloatingActionButton(
          heroTag: "ShareVerse_" + index.toString(),
          child: Icon(Icons.share),
          tooltip: AppStrings.shareVerse,
          onPressed: () async {
            Share.share(lyrics,
                subject: "Share a Verse of the song: " + song.title);
          }),
    );
  }

void favoriteSong(AppDatabase db, SongModel song, BuildContext context) {
  if (song.isfav == 1)
    db.favouriteSong(song, false);
  else {
    db.favouriteSong(song, true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(song.title + " " + AppStrings.songLiked),
      ),
    );
  }
}
