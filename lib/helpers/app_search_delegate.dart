import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vsongbook/helpers/app_settings.dart';
import "package:vsongbook/helpers/app_base.dart";
import 'package:vsongbook/utils/colors.dart';
import 'package:vsongbook/utils/constants.dart';
import 'package:vsongbook/models/song_model.dart';
import 'package:vsongbook/widgets/as_song_item.dart';
import 'package:vsongbook/screens/ee_song_view.dart';

class AppSearchDelegate extends SearchDelegate<List> {

	List<SongModel> songList, filtered;

	AppSearchDelegate(BuildContext context, this.songList) {
    filtered = songList;
  }

  @override
  String get searchFieldLabel => LangStrings.SearchNow;

	@override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
			primaryColor: Provider.of<AppSettings>(context).isDarkMode ? ColorUtils.black : ColorUtils.primaryColor,
			accentIconTheme: IconThemeData(color: Colors.white),
			primaryIconTheme: IconThemeData(color: Colors.white),
			textTheme: TextTheme(
				title: TextStyle(
						color: Color(0xFFFBF5E8)
				),
			),
			primaryTextTheme: TextTheme(
				title: TextStyle(
          color: Colors.white
				),
			),
		);
  }
  
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          filtered = songList;
					showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
		return IconButton(
			icon: AnimatedIcon(icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
			onPressed: () {
				close(context, null);
			},
		);
  }

  // Function triggered when "ENTER" is pressed.
  @override
  Widget buildResults(BuildContext context) {
    if (query.isNotEmpty) filterNow();
    return _buildItems(context);
  }

  // Results are displayed if _data is not empty.
  // Display of results changes as users type something in the search field.
  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isNotEmpty) filterNow();
    return _buildItems(context);
  }

  Widget _buildItems(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          //return AsSongItem('SongSearch_' + filtered[index].songid.toString(), filtered[index], context);
          return _buildItemRow(index, context);
        }
      ),
    );
  }

  Widget _buildItemRow(int i, BuildContext context) {
    return ListTile(
      title: Text(filtered[i].title), 
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return EeSongView(filtered[i], true, "");
        }));
      },    
    );
  }

  void filterNow() async {
    if (query.isNotEmpty)
    {
      List<SongModel> tmpList = new List<SongModel>();
      for(int i = 0; i < songList.length; i++) {
        
        if (isNumeric(query)) {
          if(songList[i].number.compareTo(int.parse(query)) == 0){
            tmpList.add(songList[i]);
          }
        }
        
        else if(songList[i].title.toLowerCase().contains(query.toLowerCase()) || 
          songList[i].alias.toLowerCase().contains(query.toLowerCase()) || 
          songList[i].content.toLowerCase().contains(query.toLowerCase())) {
          tmpList.add(songList[i]);
        }

      }
      filtered = tmpList;
    }
  }
  
}
