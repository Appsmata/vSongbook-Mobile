import 'package:flutter/material.dart';

/// Indefinate Informer widget with Text view on it
class AsInformer extends StatefulWidget {
  /// Type of informer to display: 1 for progress, 2 for success, 3 for failure
  int type;

  /// Text to show in the informer
  String text;

  /// General Color of the widget
  Color color;

  /// Container Color of the widget
  Color containerColor;

  /// Background Color of the widget
  Color backgroundColor;

  /// Radius of the border around the widget
  double borderRadius;

  AsInformerState widgetState;

  AsInformer({
    this.type,
    this.text,
    this.color,
    this.containerColor,
    this.backgroundColor,
    this.borderRadius,
  });

  @override
  createState() => widgetState = AsInformerState(
      type: this.type,
      text: this.text,
      color: this.color,
      containerColor: this.containerColor,
      backgroundColor: this.backgroundColor,
      borderRadius: this.borderRadius);

  /// initial setting up of the widget
  static Widget setUp(
      int setType,
      String setText,
      Color setColor,
      Color setContainerColor,
      Color setBackgroundColor,
      double setBorderRadius) {
    return AsInformer(
      type: setType,
      text: setText,
      color: setColor,
      containerColor: setContainerColor,
      backgroundColor: setBackgroundColor,
      borderRadius: setBorderRadius,
    );
  }

  /// hide the widget is its already being shown
  void hide() {
    widgetState.hide();
  }

  /// show the widget is its already hidden, has to be called if the widget has been created freshly
  void show() {
    widgetState.show();
  }

  /// change text on the widget
  void setText(String newtext) {
    widgetState.setNewText(newtext);
  }

  /// change the outlook of the widgeton the fly
  void modify(
      int newType,
      String newText,
      Color newColor,
      Color newBackgroundColor,
      Color newContainerColor,
      double newBorderRadius) {
    widgetState.modify(newType, newText, newColor, newBackgroundColor,
        newContainerColor, newBorderRadius);
  }
}

class AsInformerState extends State<AsInformer> {
  int type;
  String text;
  Color color;
  Color backgroundColor;
  Color containerColor;
  double borderRadius;
  bool _opacity = false;

  AsInformerState({
    this.type,
    this.text,
    this.color,
    this.containerColor,
    this.backgroundColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: !_opacity
          ? null
          : Opacity(
              opacity: _opacity ? 1 : 0,
              child: Container(
                decoration: new BoxDecoration(
                  color: backgroundColor,
                  border: Border.all(color: color),
                  boxShadow: [BoxShadow(blurRadius: 5)],
                  borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
                ),
                margin: const EdgeInsets.all(20),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: _getCenterContent(),
                ),
              ),
            ),
    );
  }

  Widget _getCenterContent() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: type > 1
                ? Icon(type == 2 ? Icons.thumb_up : Icons.warning,
                    color: color, size: 50)
                : _getCircularProgress(),
          ),
          Container(
            width: MediaQuery.of(context).size.width - 150,
            child: Text(
              text,
              style: TextStyle(color: color, fontSize: 18),
              softWrap: true,
            ),
          )
        ],
      ),
    );
  }

  Widget _getCircularProgress() {
    return CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(color));
  }

  void hide() {
    setState(() {
      _opacity = false;
    });
  }

  void show() {
    setState(() {
      _opacity = true;
    });
  }

  void setNewText(String newText) {
    setState(() {
      text = newText;
    });
  }

  void modify(
      int newType,
      String newText,
      Color newColor,
      Color newBackgroundColor,
      Color newContainerColor,
      double newBorderRadius) {
    setState(() {
      type = newType;
      text = newText;
      color = newColor;
      backgroundColor = newBackgroundColor;
      containerColor = newContainerColor;
      borderRadius = newBorderRadius;
    });
  }
}
