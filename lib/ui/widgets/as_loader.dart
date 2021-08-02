import 'package:flutter/material.dart';

/// Indefinate Informer widget with Text view on it
class AsLoader extends StatefulWidget {

  /// General Color of the widget
  Color color;
  AsLoaderState widgetState;

  AsLoader(
    { this.color }
  );

  @override
  createState() => widgetState = AsLoaderState( color: this.color );

  /// initial setting up of the widget
  static Widget setUp( Color setColor ) {
    return AsLoader( color: setColor );
  }

  /// hide the widget is its already being shown
  void hideWidget() {
    widgetState.hideWidget();
  }

  /// show the widget is its already hidden, has to be called if the widget has been created freshly
  void showWidget() {
    widgetState.showWidget();
  }

  /// change the outlook of the widgeton the fly
  void modify(Color newColor) {    
    widgetState.modifyWidget(newColor);
  }
}

class AsLoaderState extends State<AsLoader> {
  Color color;

  bool _opacity = false;

  AsLoaderState(    
    { this.color }
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      child: !_opacity ? null : Opacity(
        opacity: _opacity ? 1 : 0,
        child: Container(
          decoration: new BoxDecoration( 
            color: Colors.white,
            border: Border.all(color: color),
            boxShadow: [BoxShadow(blurRadius: 5)],
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          margin: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: _getCircularProgress(),
          ),
        ),
      ),
    );

  }

  Widget _getCircularProgress() {
    return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(color));
  }

  void hideWidget() {
    setState(() {
      _opacity = false;
    });
  }

  void showWidget() {
    setState(() {
      _opacity = true;
    });
  }

  void modifyWidget(Color newColor) {
    setState(() {
      color = newColor;
    });
  }

}
