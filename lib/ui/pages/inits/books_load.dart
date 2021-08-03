import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/app_settings.dart';
import '../../../services/app_helper.dart';
import '../../../services/app_futures.dart';
import '../../../data/models/list_item.dart';
import '../../../data/base/event_object.dart';
import '../../../data/callbacks/Book.dart';
import '../../../utils/api_utils.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/colors.dart';
import '../../widgets/as_informer.dart';
import '../../widgets/alerts/alert.dart';
import '../../widgets/alerts/alert_button.dart';
import '../../widgets/alerts/alert_style.dart';
import '../info/about_app.dart';
import '../info/donate.dart';
import '../info/help_desk.dart';
import 'book_item.dart';
import 'songs_load.dart';

class BooksLoad extends StatefulWidget {
  @override
  BooksLoadState createState() => BooksLoadState();
}

class BooksLoadState extends State<BooksLoad> {
  final globalKey = new GlobalKey<ScaffoldState>();
  var appBar = AppBar();

  AsInformer informer = AsInformer.setUp(1, AppStrings.fetchingData,
      ColorUtils.primaryColor, Colors.transparent, Colors.white, 10);

  List<ListItem<Book>> selected = [], bookList = [];
  List<Book> books = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initBuild(context));
  }

  /// Method to run anything that needs to be run immediately after Widget build
  void initBuild(BuildContext context) async {
    requestData();
  }

  // Method to request data either from the db or server
  void requestData() async {
    informer.show();
    EventObject eventObject = await getSongbooks();

    if (mounted) {
      setState(() {
        informer.hide();
        switch (eventObject.id) {
          case EventConstants.requestSuccessful:
            Alert(
              context: context,
              alertTitle: AppStrings.justAMinute,
              alertMessage: AppStrings.takeTimeSelecting,
              style: AlertStyle(alertHeight: 150),
              buttons: [
                AlertButton(
                  text: AppStrings.okayGotIt,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ).show();

            books = [];
            books = Book.fromData(eventObject.object);
            bookList = [];
            for (int i = 0; i < books.length; i++)
              bookList.add(ListItem<Book>(books[i]));
            break;

          case EventConstants.requestUnsuccessful:
            Alert(
              context: context,
              alertTitle: AppStrings.areYouConnected,
              alertMessage: AppStrings.noConnection,
              style: AlertStyle(alertHeight: 150),
              buttons: [
                AlertButton(
                  text: AppStrings.okayGotIt,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ).show();
            break;

          case EventConstants.noInternetConnection:
            Alert(
              context: context,
              alertTitle: AppStrings.areYouConnected,
              alertMessage: AppStrings.noConnection,
              style: AlertStyle(alertHeight: 150),
              buttons: [
                AlertButton(
                  text: AppStrings.okayGotIt,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ).show();
            break;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: theAppBar(),
      body: Column(children: <Widget>[
        headerPanel(),
        Stack(children: <Widget>[
          midPanel(),
          Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
            height: 150,
            child: Center(
              child: informer,
            ),
          ),
        ]),
        footerPanel(context),
      ]),
    );
  }

  Widget theAppBar() {
    return AppBar(
      title: Text(AppStrings.setUpTheApp + AppStrings.appName),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            Alert(
              context: context,
              alertTitle: AppStrings.displaySettings,
              alertWidget: ListView(
                children: <Widget>[
                  Consumer<AppSettings>(
                      builder: (context, AppSettings settings, _) {
                    return ListTile(
                      onTap: () {},
                      leading: Icon(settings.isDarkMode
                          ? Icons.brightness_4
                          : Icons.brightness_7),
                      title: Text(AppStrings.darkMode),
                      trailing: Switch(
                        onChanged: (bool value) {
                          settings.setDarkMode(value);
                        },
                        value: settings.isDarkMode,
                      ),
                    );
                  }),
                  Divider(),
                ],
              ),
              buttons: [
                AlertButton(
                  text: AppStrings.okayDone,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ).show();
          },
        ),
        menuPopup(),
      ],
    );
  }

  Widget menuPopup() => PopupMenuButton<int>(
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: Text(AppStrings.supportUs),
          ),
          PopupMenuItem(
            value: 2,
            child: Text(AppStrings.helpFeedback),
          ),
          PopupMenuItem(
            value: 3,
            child: Text(AppStrings.aboutTheApp + AppStrings.appName),
          ),
        ],
        onCanceled: () {},
        onSelected: (value) {
          selectedMenu(value, context);
        },
        icon: Icon(
          Theme.of(context).platform == TargetPlatform.iOS
              ? Icons.more_horiz
              : Icons.more_vert,
        ),
      );

  void selectedMenu(int menu, BuildContext context) {
    switch (menu) {
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Donate();
        }));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return HelpDesk();
        }));
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return AboutApp();
        }));
        break;
    }
  }

  Widget loadingGettingReady() {
    return Container(
      height: (MediaQuery.of(context).size.height -
          (appBar.preferredSize.height * 2)),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Stack(
        children: <Widget>[
          Center(child: Container(width: 300, height: 120)),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.deepOrange)),
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Text(AppStrings.gettingReady,
                      style: TextStyle(fontSize: 18)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget headerPanel() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            AppStrings.createCollection,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TextButton(
            child: Text(AppStrings.learnMore),
            onPressed: () {
              Alert(
                context: context,
                alertTitle: AppStrings.justAMinute,
                alertMessage: AppStrings.takeTimeSelecting,
                style: AlertStyle(alertHeight: 150),
                buttons: [
                  AlertButton(
                    text: AppStrings.okayGotIt,
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ).show();
            },
          ),
        ],
      ),
    );
  }

  Widget midPanel() {
    return Container(
      height: (MediaQuery.of(context).size.height - 190),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: books.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              child: BookItem(index, books, bookList, context),
              onTap: () {
                onBookSelected(bookList[index]);
              },
              onLongPress: () {
                onBookSelected(bookList[index]);
              },
            );
          }),
    );
  }

  void onBookSelected(ListItem tapped) {
    setState(() {
      tapped.isSelected = !tapped.isSelected;
    });
    if (tapped.isSelected) {
      try {
        selected.add(tapped);
      } catch (Exception) {}
    } else {
      try {
        selected.remove(tapped);
      } catch (Exception) {}
    }
  }

  Widget footerPanel(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      height: 50,
      child: Center(
        child: Container(
          width: 300,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: FloatingActionButton.extended(
                  icon: Icon(Icons.refresh, color: ColorUtils.white),
                  label: Text(
                    AppStrings.reload,
                    style: TextStyle(color: ColorUtils.white),
                  ),
                  onPressed: () => requestData(),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: FloatingActionButton.extended(
                  icon: Icon(Icons.check, color: ColorUtils.white),
                  label: Text(
                    AppStrings.proceed,
                    style: TextStyle(color: ColorUtils.white),
                  ),
                  onPressed: () => areYouDoneDialog(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> areYouDoneDialog(BuildContext context) {
    if (selected.length > 0) {
      String selectedbooks = "";
      for (int i = 0; i < selected.length; i++) {
        selectedbooks = selectedbooks +
            (i + 1).toString() +
            ". " +
            selected[i].data.title +
            " - " +
            selected[i].data.qcount +
            AppStrings.songsPrefix;
      }

      return Alert(
        context: context,
        alertTitle: AppStrings.doneSelecting,
        alertWidget: Text(selectedbooks),
        style: AlertStyle(alertHeight: (selected.length * 30).toDouble()),
        buttons: [
          AlertButton(
            text: AppStrings.goBack,
            onPressed: () => Navigator.pop(context),
          ),
          AlertButton(
            text: AppStrings.proceed,
            onPressed: () {
              Navigator.pop(context);
              goToNextScreen();
            },
          ),
        ],
      ).show();
    } else
      return Alert(
        context: context,
        alertTitle: AppStrings.justAMinute,
        alertMessage: AppStrings.noSelection,
        style: AlertStyle(alertHeight: 150),
        buttons: [
          AlertButton(
            text: AppStrings.okayGotIt,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ).show();
  }

  /// Proceed to a newer screen
  Future<void> goToNextScreen() async {
    informer.show();
    await saveBooks(selected);
    informer.hide();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SongsLoad()));
  }
}
