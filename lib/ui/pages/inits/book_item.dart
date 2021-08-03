import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/list_item.dart';
import '../../../services/app_settings.dart';
import '../../../utils/app_utils.dart';
import '../../../data/callbacks/Book.dart';

// ignore: must_be_immutable
class BookItem extends StatelessWidget {
  final BuildContext context;
  List<ListItem<Book>> bookList;
  List<Book> books = [];
  int index;

  BookItem(this.index, this.books, this.bookList, this.context);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: bookList[index].isSelected
          ? Colors.deepOrange
          : Provider.of<AppSettings>(context).isDarkMode
              ? Colors.black
              : Colors.white,
      elevation: 5,
      child: Row(
        children: <Widget>[
          bookIcon(),
          bookText(),
        ],
      ),
    );
  }

  Widget bookIcon() {
    return Container(
      height: 80,
      width: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(5),
          topLeft: Radius.circular(5),
        ),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage("assets/images/book.jpg"),
        ),
      ),
    );
  }

  Widget bookText() {
    return Container(
      margin: EdgeInsets.only(left: 5),
      height: 70,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            books[index].title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: bookList[index].isSelected
                  ? Colors.white
                  : Provider.of<AppSettings>(context).isDarkMode
                      ? Colors.white
                      : Colors.black,
            ),
          ),
          SizedBox(height: 5),
          Text(
            books[index].qcount +
                " " +
                books[index].backpath +
                AppStrings.songsInside +
                books[index].content,
            style: TextStyle(
              fontSize: 15,
              color: bookList[index].isSelected
                  ? Colors.white
                  : Provider.of<AppSettings>(context).isDarkMode
                      ? Colors.white
                      : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
